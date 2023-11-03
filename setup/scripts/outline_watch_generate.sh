#!/bin/bash

# This script watches for modifications to docs/_data/outline.csv.
# When the file is modified, a Python script is executed to generate markdown.

# Function to get the last modification time of the file.
get_last_mod_time() {
    stat -c %Y "$1"
}

# Full path to the file to watch.
file_to_watch="docs/_data/outline.csv"

# Interval between checks, in seconds.
poll_interval=1

# Check if the file exists before starting.
if [[ ! -f "$file_to_watch" ]]; then
    echo "The file $file_to_watch does not exist."
    exit 1
fi

# Initialize the previous modification time.
prev_mtime=$(get_last_mod_time "$file_to_watch")

# Function to run when the script exits.
cleanup() {
    echo "Exiting script."
    exit 0
}

# Trap SIGINT (Ctrl+C) and SIGTERM to run the cleanup function.
trap cleanup SIGINT SIGTERM

# Main loop to watch for file modifications.
while true; do
    current_mtime=$(get_last_mod_time "$file_to_watch")

    if [[ "$current_mtime" -ne "$prev_mtime" ]]; then
        # Run the Python script when a change is detected.
        python3 setup/scripts/generate_outline_md.py
        # Update the previous modification time.
        prev_mtime=$current_mtime
    fi

    # Wait for the specified interval before checking again.
    sleep "$poll_interval"
done
