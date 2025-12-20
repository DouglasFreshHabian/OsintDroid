<h1 align="center">
🕵️‍♂️ OsintDroid
</h1>

[![asciicast](https://asciinema.org/a/763143.svg)](https://asciinema.org/a/763143)

**OSINTDroid** is a Bash-based Android forensic tool developed by **Fresh Forensics**. It allows you to quickly extract and analyze various types of data from an Android device using ADB (Android Debug Bridge). The tool is designed for **educational purposes, privacy awareness, and mobile forensics demonstrations**.

---

## 👤 Features

OsintDroid provides a simple, menu-driven interface with the following options:

1. **Number of Reboots** – Retrieve the device boot count.
2. **List Registered Emails** – Extract all emails used on the device.
3. **List Account Applications** – Display apps associated with user accounts.
4. **List Phone Contacts** – Retrieve all contacts with associated phone numbers.
5. **Dump Call Logs** – Export the device’s call history.
6. **Dump SMS** – Export SMS messages stored on the device.
7. **List All APKs** – Show all installed applications.
8. **List 3rd Party Apps** – Show only non-system installed applications.
9. **Dump Secret Codes** – Enumerate Android secret codes from system packages.
0. **Exit** – Quit the tool.

---

## 🛠️ Requirements

- **Linux** or a Bash environment
- **ADB (Android Debug Bridge)** installed and accessible in your system PATH
- An **Android device** with **USB debugging enabled**
- Permission to access the device via ADB

---

## ⚙️ Installation

1. Clone this repository:

```bash
git clone https://github.com/DouglasFreshHabian/OsintDroid.git
cd OsintDroid
````

2. Make the script executable:

```bash
chmod +x OsintDroid.sh
```

3. Connect your Android device via USB and ensure **ADB debugging** is enabled.

---

## 📱 Usage

Run the script:

```bash
./OsintDroid.sh
```

* A green banner will appear followed by the interactive menu.
* Enter the number corresponding to the action you want to perform.
* For example, entering `6` will dump SMS messages to your terminal.
* Option `9` will enumerate Android secret codes from system packages.

---

## 📑 Notes

* All actions are **read-only** and safe for educational and testing purposes on devices you own.
* Make sure **USB debugging** is enabled and the device authorizes your computer.
* Secret codes are system-specific; some may not return results depending on your device model and Android version.

---

## ⚖️ Legal & Ethical Notice

This toolkit is for **authorized forensic analysis only**.
Ensure compliance with local laws and privacy regulations. Unauthorized data extraction may violate legal boundaries.

---

## 💬 Feedback & Contributions

If you have ideas, want to add new ADB command modules, or improve automation — open an issue or submit a pull request!
Let’s build an open, transparent, and responsible forensic community.

---

## ☕ Support This Project

If **OsintDroid™** helps your OSINT, consider supporting continued development:

<p align="center">
  <a href="https://www.buymeacoffee.com/dfreshZ" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
</p>

---

<!-- 
    Fresh Forensics, LLC | Douglas Fresh Habian | 2025
    github.com/DouglasFreshHabian
    freshforensicsllc@tuta.com
-->

