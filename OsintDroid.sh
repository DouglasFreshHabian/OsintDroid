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
    echo -e "${GREEN}  9)${RESET} Dump Secret Codes"
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
    echo -e "${GREEN}Dumping Android secret codes from system packages...${RESET}"
    echo

    # Get system package names
    package_name_trim=$(adb shell pm list packages -s -f \
        | awk -F 'package:' '{print $2}' \
        | awk -F '=' '{print $2}')

    for pkg in ${package_name_trim}; do

        # Print package name
        echo -e "${GREEN}Package:${RESET} ${pkg}"

        adb shell pm dump "${pkg}" \
            | grep -E 'Scheme: "android_secret_code"|Authority: "[0-9].*"|Authority: "[A-Z].*"' \
            | while IFS= read -r line; do
                echo -e "  ${GREEN}${line}${RESET}"
            done

        echo
    done

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
