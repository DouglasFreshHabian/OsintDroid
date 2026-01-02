#!/usr/bin/env bash

# ================================================
#          OSINTDROID BY FRESH FORENSICS
# ================================================

# --- Colors ---
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

# --- Banner ---
banner() {
    color_code=$GREEN

    # Print the banner
    echo -e "${color_code}"
    cat << "EOF"

⣿⣿⣿⣿⣿⣿⣧⠻⣿⣿⠿⠿⠿⢿⣿⠟⣼⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⠟⠃⠁⠀⠀⠀⠀⠀⠀⠘⠻⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⡿⠃⠀⣴⡄⠀⠀⠀⠀⠀⣴⡆⠀⠘⢿⣿⣿⣿⣿
⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿
⣿⠿⢿⣿⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⣿⡿⠿⣿
⡇⠀⠀⣿  OsintDroid  ⠀⣿⠀⠀⢸
⡇⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⢸
⡇⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⢸
⡇⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⢸
⣧⣤⣤⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣤⣤⣼
⣿⣿⣿⣿⣶⣤⡄⠀⠀⠀⣤⣤⣤⠀⠀⠀⢠⣤⣴⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⣿⣿⣿⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣤⣤⣴⣿⣿⣿⣦⣤⣤⣾⣿⣿⣿⣿⣿⣿

EOF
    echo -e "${RESET}"  # Reset color
}

# --- Menu ---
menu() {
    echo -e "${YELLOW}Choose an option:${RESET}"
    echo -e "${GREEN}  1)${RESET} Number of Reboots"
    echo -e "${GREEN}  2)${RESET} List Registered Emails"
    echo -e "${GREEN}  3)${RESET} List Account Applications"
    echo -e "${GREEN}  4)${RESET} List Phone Contacts"
    echo -e "${GREEN}  5)${RESET} Dump Call Logs"
    echo -e "${GREEN}  6)${RESET} Dump SMS"
    echo -e "${GREEN}  7)${RESET} List All APKs"
    echo -e "${GREEN}  8)${RESET} List 3rd Party"
    echo -e "${GREEN}  9)${RESET} Dump Secret Codes (Filtered + JSON Option)"
    echo -e "${GREEN}  0)${RESET} Exit"
    echo
}

# --- Option Functions ---
option_1() {
    echo -e "${GREEN}Running: adb shell settings list global${RESET}"
    adb shell settings list global|grep "boot_count="|cut -d= -f2|head -n 1|xargs echo "Booted:"|sed 's/$/ times/g'
}

option_2() {
    echo -e "${GREEN}Listing all emails used on device:${RESET}"
    adb shell dumpsys account | grep -aE -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b"
}

option_3() {
    echo -e "${GREEN}Listing all applications the user has an account on...${RESET}"
    adb shell dumpsys account|grep -i com.*$ -o|cut -d' ' -f1|cut -d} -f1|grep -v com$
}

option_4() {
    echo -e "${GREEN}Listing all contacts and associated phone numbers...${RESET}"
    adb shell content query --uri content://contacts/phones/ --projection display_name:number 
}

option_5() {
    echo -e "${GREEN}Dumping all call logs...${RESET}"
    adb shell content query --uri content://call_log/calls
}

option_6() {
    echo -e "${GREEN}Dumping all sms messages...${RESET}"
    adb shell content query --uri content://sms/
}

option_7() {
    echo -e "${GREEN}Listing all install packages...${RESET}"
    adb shell pm list packages
}

option_8() {
    echo -e "${GREEN}Listing all 3rd party packages...${RESET}"
    adb shell pm list packages -3
}

option_9() {
    # --- ask for JSON export ---
    local json_file=""
    local first_json_entry=true
    
    echo -e "${CYAN}Output to JSON file? (y/N):${RESET} \c"
    read -r want_json
    if [[ "$want_json" =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}Enter filename (e.g. codes.json):${RESET} \c"
        read -r json_file
        # Fallback Name, falls leer
        if [[ -z "$json_file" ]]; then json_file="secret_codes.json"; fi
        
        echo "[" > "$json_file"
        echo -e "${YELLOW}Writing output to ${json_file}...${RESET}"
    fi

    echo -e "${GREEN}Scanning system packages for Android secret codes...${RESET}"
    echo

    # Get system package names
    package_name_trim=$(adb shell pm list packages -s -f \
        | awk -F 'package:' '{print $2}' \
        | awk -F '=' '{print $2}')

    for pkg in ${package_name_trim}; do

        # we store the codes in variable instead of printing them directly
        # this "|| true" prevents errors if egrep does not find anything
        codes=$(adb shell pm dump "${pkg}" \
            | grep -E 'Scheme: "android_secret_code"|Authority: "[0-9].*"|Authority: "[A-Z].*"' || true)

        # if var is not empty, print it
        if [[ -n "$codes" ]]; then
            
            # --- console output ---
            echo -e "${GREEN}Package:${RESET} ${pkg}"
            
            echo "$codes" | while IFS= read -r line; do
                echo -e "  ${GREEN}${line}${RESET}"
            done
            echo

            # --- JSON-Export (if activated) ---
            if [[ -n "$json_file" ]]; then
                # put a comma if it is not the first entry
                if [ "$first_json_entry" = true ]; then
                    first_json_entry=false
                else
                    echo "," >> "$json_file"
                fi

                # format codes for json (maybe do it nicer):
                # 1. escape backslashes and semicolons
                # 2. put every line in quotation marks
                # 3. combine lines with commas
                json_codes_array=$(echo "$codes" | sed 's/\\/\\\\/g; s/"/\\"/g' | awk '{print "\""$0"\""}' | paste -sd, -)

                # write the JSON-object
                echo "  { \"package\": \"$pkg\", \"codes\": [$json_codes_array] }" >> "$json_file"
            fi
        fi
    done

    # close the JSON array
    if [[ -n "$json_file" ]]; then
        echo "]" >> "$json_file"
        echo -e "${GREEN}JSON export saved to: ${json_file}${RESET}"
    fi

    echo -e "${GREEN}Secret code dump complete.${RESET}"
}

# --- Main Loop ---
while true; do
    banner
    menu
    read -p "$(echo -e $MAGENTA$BOLD'Enter choice: '$RESET)" choice

    case "$choice" in
        1) option_1; read -p "Press Enter to continue..." ;;
        2) option_2; read -p "Press Enter to continue..." ;;
        3) option_3; read -p "Press Enter to continue..." ;;
        4) option_4; read -p "Press Enter to continue..." ;;
        5) option_5; read -p "Press Enter to continue..." ;;
        6) option_6; read -p "Press Enter to continue..." ;;
        7) option_7; read -p "Press Enter to continue..." ;;
        8) option_8; read -p "Press Enter to continue..." ;;
        9) option_9; read -p "Press Enter to continue..." ;;
        0) echo -e "${GREEN}Exiting.${RESET}"; exit 0 ;;
        *) echo -e "${RED}Invalid option.${RESET}"; sleep 1 ;;
    esac
done
