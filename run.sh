#!/bin/sh
#set -x
cd /home/stellaris/stellaris-dashboard

CONFIG_LOC="/home/stellaris/stellaris-dashboard/config.yml"
SAVE_FILE_LOC="/home/stellaris/.local/share/Paradox Interactive/Stellaris/save games"
OUTPUT_LOC="/home/stellaris/stellaris-dashboard/output"

apply_settings () {
python - <<EOF
import os, sys
os.chdir("/home/stellaris/stellaris-dashboard")
sys.path.append("/home/stellaris/stellaris-dashboard")
from stellarisdashboard import config

config.logger.warning("Updating settings for Docker")
config.CONFIG.host = "0.0.0.0"
config.CONFIG.log_to_file = False
config.CONFIG.polling_interval = 1
config.CONFIG.check_version = False
if hasattr(config.CONFIG, "production"):
  config.CONFIG.production = True

config.CONFIG.write_to_file()
EOF
}

apply_settings
if [ -e "${SAVE_FILE_LOC}" ]; then
  NUM_SAVES=$(find "${SAVE_FILE_LOC}" -type f -name "*.sav" -print | wc -l)
  NUM_DBS=0
  if [ -e "${OUTPUT_LOC}" ]; then
    NUM_DBS=$(find "${OUTPUT_LOC}" -type f -name "*.db" -print | wc -l)
  fi
  # Parse saves if saves exist and nothing has been parsed before
  if [ $NUM_SAVES -gt 0 ] && [ $NUM_DBS -eq 0 ] && [ -z "$SKIP_INITIAL_PARSE" ]; then
    echo " ** PARSING EXISTING SAVES -- THIS MAY TAKE A WHILE -- CONTINUING IN 5s **"
    sleep 5
    python -m stellarisdashboard.cli parse-saves
  fi
fi

exec python -m stellarisdashboard
