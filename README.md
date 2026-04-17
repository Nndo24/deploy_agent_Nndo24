# Automated Project Bootstrapping & Process Management

This repository contains a **Project Factory** shell script designed to automate the deployment of a Student Attendance Tracker. This project demonstrates the power of **Infrastructure as Code (IaC)**, dynamic configuration using `sed`, and graceful process management with signal traps.

## 📋 Project Overview

The core of this project is the `setup_project.sh` script. It automates:
1.  **Directory Architecture:** Creating a structured workspace for the attendance tracker.
2.  **Dynamic Configuration:** Using `sed` to update attendance thresholds in `config.json` via user input.
3.  **Process Management:** Implementing a `trap` to handle `SIGINT` (Ctrl+C), ensuring a clean workspace by archiving the state and deleting incomplete directories.
4.  **Environment Validation:** Performing health checks for Python 3 and verifying the final directory structure.

---

## 🚀 How to Run the Script

Follow these steps to bootstrap the project:

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/YourGitHubUsername/deploy_agent_YourGitHubUsername.git
    cd deploy_agent_YourGitHubUsername
    ```

2.  **Ensure Execution Permissions:**
    ```bash
    chmod +x setup_project.sh
    ```

3.  **Execute the Script:**
    ```bash
    ./setup_project.sh
    ```
    - You will be prompted to enter a **project name suffix** (e.g., `spring2026` ).
    - You will be asked if you want to **update attendance thresholds** (Warning/Failure).

4.  **Run the Attendance Tracker:**
    After a successful setup, navigate into the new directory and run the Python application:
    ```bash
    cd attendance_tracker_spring2026
    python3 attendance_checker.py
    ```

---

## 📦 Triggering the Archive Feature (Signal Trap)

One of the key features of this "Project Factory" is its ability to handle interruptions gracefully.

- **How to Trigger:** While the `setup_project.sh` script is running (e.g., while it's waiting for your input), press `Ctrl + C` on your keyboard.
- **What Happens:** The script will catch the `SIGINT` signal, immediately bundle the current state of the directory into a `.tar.gz` archive, and then delete the incomplete directory to keep your workspace clean.

---

## 📁 Directory Structure

After execution, the script generates the following structure:
```text
attendance_tracker_spring2026/
├── attendance_checker.py   # Main logic
├── Helpers/                # Configuration & Assets
│   ├── assets.csv          # Student data
│   └── config.json         # Threshold settings
└── reports/                # Logging
    └── reports.log         # System logs
