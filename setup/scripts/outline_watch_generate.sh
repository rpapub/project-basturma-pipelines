#!/bin/bash

# This script watches for modifications to docs/_data/outline.csv.
# When the file is modified, a Python script is executed to generate markdown.

# Enable debug mode based on command line parameter
DEBUG_MODE=0
for arg in "$@"; do
    case $arg in
    -d | --debug)
        DEBUG_MODE=1
        shift # Remove --debug from processing
        ;;
    esac
done

# Function to log debug messages if debug mode is enabled
debug_log() {
    if [[ $DEBUG_MODE -eq 1 ]]; then
        echo "DEBUG: $1"
    fi
}

# Function to get the last modification time of the file.
get_last_mod_time() {
    stat -c %Y "$1"
}

# Full path to the file to watch.
file_to_watch="docs/_data/outline.csv"

# Interval between checks, in seconds.
poll_interval=1

# Grace interval in seconds.
grace_interval=4

# Check if the file exists before starting.
if [[ ! -f "$file_to_watch" ]]; then
    echo "The file $file_to_watch does not exist."
    exit 1
fi

debug_log "Watching ${file_to_watch} for changes."

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
    debug_log "Current mtime: $current_mtime, Previous mtime: $prev_mtime"

    # Compare if current mtime is fresher than previous mtime plus the grace interval.
    if [[ "$current_mtime" -gt "$((prev_mtime + grace_interval))" ]]; then
        debug_log "Change detected in ${file_to_watch} after grace interval."
        # Run the Python script when a change is detected.
        python3 setup/scripts/generate_outline_md.py
        debug_log "Ran the Python script to generate markdown."
        # Update the previous modification time.
        prev_mtime=$current_mtime
    fi

    # Wait for the specified interval before checking again.
    sleep "$poll_interval"
done
