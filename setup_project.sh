#!/bin/bash

# --- Configuration Variables ---
PROJECT_NAME_PREFIX="attendance_tracker"
MAIN_SCRIPT="attendance_checker.py"
ASSETS_FILE="assets.csv"
CONFIG_FILE="config.json"
LOG_FILE="reports.log"

# --- 1. Directory Architecture ---
# Prompt user for input string
read -p "Enter a string for the project directory name (e.g., 'spring2026'): " USER_INPUT

if [ -z "$USER_INPUT" ]; then
    echo "Error: Project name suffix cannot be empty. Exiting."
    exit 1
fi

PARENT_DIR="${PROJECT_NAME_PREFIX}_${USER_INPUT}"
HELPERS_DIR="${PARENT_DIR}/Helpers"
REPORTS_DIR="${PARENT_DIR}/reports"

# Function to handle SIGINT (Ctrl+C)
cleanup_and_archive() {
    echo -e "\n\nSIGINT received. Archiving project state and cleaning up..."
    ARCHIVE_NAME="${PARENT_DIR}_archive.tar.gz"
    # Create the archive if the directory exists
    if [ -d "$PARENT_DIR" ]; then
        tar -czf "$ARCHIVE_NAME" "$PARENT_DIR"
        rm -rf "$PARENT_DIR"
        echo "Project archived as \"$ARCHIVE_NAME\" and directory \"$PARENT_DIR\" deleted."
    else
        echo "No project directory to archive."
    fi
    exit 0
}

# Set the trap for SIGINT
trap cleanup_and_archive SIGINT

echo "Creating directory structure for '$PARENT_DIR'..."
mkdir -p "$HELPERS_DIR" "$REPORTS_DIR"

# Move source files into their correct locations
# Note: Using cp instead of mv here so you can run the script multiple times if needed
if [ -f "$MAIN_SCRIPT" ]; then cp "$MAIN_SCRIPT" "$PARENT_DIR/"; fi
if [ -f "$ASSETS_FILE" ]; then cp "$ASSETS_FILE" "$HELPERS_DIR/"; fi
if [ -f "$CONFIG_FILE" ]; then cp "$CONFIG_FILE" "$HELPERS_DIR/"; fi
if [ -f "$LOG_FILE" ]; then cp "$LOG_FILE" "$REPORTS_DIR/"; fi

echo "Directory structure created successfully."

# --- 2. Dynamic Configuration (Stream Editing) ---
echo -e "\n--- Dynamic Configuration ---"
read -p "Do you want to update attendance thresholds? (y/n): " UPDATE_THRESHOLDS

if [[ "$UPDATE_THRESHOLDS" =~ ^[Yy]$ ]]; then
    read -p "Enter new Warning threshold (default 75%): " NEW_WARNING
    read -p "Enter new Failure threshold (default 50%): " NEW_FAILURE

    # Use sed to update config.json in-place
    # These commands look for "warning": <number> and replace it
    sed -i "s/\"warning\": [0-9]*/\"warning\": ${NEW_WARNING:-75}/" "$HELPERS_DIR/$CONFIG_FILE"
    sed -i "s/\"failure\": [0-9]*/\"failure\": ${NEW_FAILURE:-50}/" "$HELPERS_DIR/$CONFIG_FILE"
    echo "Attendance thresholds updated in $CONFIG_FILE."
else
    echo "Attendance thresholds not updated."
fi

# --- 4. Environment Validation ---
echo -e "\n--- Environment Validation ---"

# Check for python3 installation
if command -v python3 &>/dev/null; then
    echo "SUCCESS: Python 3 is installed: $(python3 --version)"
else
    echo "WARNING: Python 3 is not installed. Please install it to run the attendance checker."
fi

# Verify application directory structure
if [ -d "$PARENT_DIR" ] && \
   [ -f "$PARENT_DIR/$MAIN_SCRIPT" ] && \
   [ -d "$HELPERS_DIR" ] && \
   [ -f "$HELPERS_DIR/$ASSETS_FILE" ] && \
   [ -f "$HELPERS_DIR/$CONFIG_FILE" ] && \
   [ -d "$REPORTS_DIR" ] && \
   [ -f "$REPORTS_DIR/$LOG_FILE" ]; then
    echo "SUCCESS: Application directory structure is correct."
else
    echo "ERROR: Application directory structure is incorrect or incomplete."
    exit 1
fi

echo -e "\nProject setup complete for '$PARENT_DIR'."
echo "To run the checker: cd $PARENT_DIR && python3 $MAIN_SCRIPT"
