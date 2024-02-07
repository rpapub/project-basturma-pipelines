.PHONY: outline_watch_generate

outline_watch_generate:
	@echo "Starting to watch for changes in outline.csv..."
	@/bin/bash setup/scripts/outline_watch_generate.sh
