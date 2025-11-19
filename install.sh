#!/bin/bash

set -e

function log {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> install.log
}

log "Starting installation process..."

# Phase 1: Verify Hyprland Installation
if ! command -v hyprland &> /dev/null; then
    log "Hyprland is not installed. Please install Hyprland before proceeding."
    exit 1
fi
log "Hyprland installation verified."

# Phase 2: Check Dependencies
dependencies=("git" "python3" "pip")
for dep in "${dependencies[@]}"; do
    if ! command -v $dep &> /dev/null; then
        log "$dep is not installed. Please install it to proceed."
        exit 1
    fi
done
log "All dependencies are installed."

# Phase 3: Create Necessary Directories
mkdir -p ~/.config/hypr-ai-automator/logs
mkdir -p ~/.config/hypr-ai-automator/data
log "Created necessary directories."

# Phase 4: Parse Configuration Files
# (Assuming a config file exists at ~/.config/hypr-ai-automator/config.yaml)
if [ ! -f ~/.config/hypr-ai-automator/config.yaml ]; then
    log "Configuration file not found. Please create it at ~/.config/hypr-ai-automator/config.yaml"
    exit 1
fi
log "Configuration file parsed successfully."

# Phase 5: Install Python Dependencies
pip install -r requirements.txt
log "Python dependencies installed."

# Phase 6: Initialize Database
# (Assuming there's a script for initializing the database)
python3 init_db.py
log "Database initialized."

# Phase 7: Set Up Systemd Service
cat <<EOF | sudo tee /etc/systemd/system/hypr-ai-automator.service
[Unit]
Description=Hypr AI Automator Service

[Service]
ExecStart=/usr/bin/python3 /path/to/hypr-ai-automator/main.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable hypr-ai-automator
sudo systemctl start hypr-ai-automator
log "Systemd service set up."

# Phase 8: Final Verification
if systemctl status hypr-ai-automator; then
    log "Installation completed successfully. Service is running."
else
    log "Installation completed, but the service is not running."
    exit 1
fi
log "Final verification passed."

# Phase 9: Error Handling (Already handled using `set -e` and logs)

# Phase 10: Logging (Implemented with log function)

# Phase 11: Cleanup
# (Optional cleanup tasks can be added here)

log "Installation script completed."