# Backup Automation (Bash)

Simple Bash script that automates folder backups with timestamped archives,
rotation and logging. Portfolio project to practice Linux administration
and Bash scripting.

## Features
- Timestamped .tar.gz archives
- Configurable source and destination folders
- Rotation: keeps only the 5 most recent backups
- Logging to backup.log
- Exit codes for cron automation

## Usage
```bash
chmod +x backup.sh
./backup.sh [SOURCE_DIR] [BACKUP_DIR]
# defaults: ~/documents -> ~/backups
