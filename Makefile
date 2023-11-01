
watch_generate_outline_md:
	prev_mtime=$(stat -c %Y docs/_data/outline.csv); while true; do current_mtime=$(stat -c %Y docs/_data/outline.csv); if [[ "$current_mtime" -ne "$prev_mtime" ]]; then python3 setup/scripts/generate_outline_md.py; sleep 1; prev_mtime=$(stat -c %Y docs/_data/outline.csv); fi; sleep 1; done