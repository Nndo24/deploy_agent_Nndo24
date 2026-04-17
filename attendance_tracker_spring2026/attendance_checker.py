import json
import csv
import os
import sys

def check_attendance():
    print("--- Student Attendance Tracker ---")
    
    # Define paths based on expected structure
    config_path = os.path.join('Helpers', 'config.json')
    assets_path = os.path.join('Helpers', 'assets.csv')
    log_path = os.path.join('reports', 'reports.log')

    # Check if files exist
    if not os.path.exists(config_path):
        print(f"Error: {config_path} not found.")
        return

    # Load configuration
    try:
        with open(config_path, 'r') as f:
            config = json.load(f)
    except Exception as e:
        print(f"Error reading config: {e}")
        return

    warning_threshold = config.get('thresholds', {}).get('warning', 75)
    failure_threshold = config.get('thresholds', {}).get('failure', 50)

    print(f"Thresholds: Warning={warning_threshold}%, Failure={failure_threshold}%")

    # Read assets (student data)
    if os.path.exists(assets_path):
        print("\nStudent Records:")
        with open(assets_path, mode='r') as file:
            reader = csv.DictReader(file)
            for row in reader:
                print(f"ID: {row['student_id']} | Name: {row['name']} | Status: {row['status']}")
    
    # Log the run
    if os.path.exists(os.path.dirname(log_path)):
        with open(log_path, 'a') as log:
            log.write(f"Attendance check performed successfully.\n")

if __name__ == "__main__":
    check_attendance()
