#!/bin/bash
# backup.sh - automated folder backup with rotation and logging
# Author: Vanilson Nkavandu | Version 0.1

SOURCE_DIR="${1:-$HOME/documents}"    # pasta a copiar (argumento 1, ou ~/documents)
BACKUP_DIR="${2:-$HOME/backups}"      # onde guardar (argumento 2, ou ~/backups)
MAX_BACKUPS=5                         # manter só os 5 mais recentes
LOG_FILE="$BACKUP_DIR/backup.log"

mkdir -p "$BACKUP_DIR"                # cria a pasta de destino se não existir
TIMESTAMP=$(date +%Y%m%d_%H%M%S)      # data e hora para o nome do ficheiro
ARCHIVE="backup_${TIMESTAMP}_$$.tar.gz"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup started: $SOURCE_DIR" | tee -a "$LOG_FILE"

if [ ! -d "$SOURCE_DIR" ]; then       # se a pasta de origem não existir...
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: source not found: $SOURCE_DIR" | tee -a "$LOG_FILE"
    exit 1                            # ...aborta com código de erro 1
fi

tar -czf "$BACKUP_DIR/$ARCHIVE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>>"$LOG_FILE"

if [ $? -eq 0 ]; then                 # $? = código do tar; 0 quer dizer sucesso
    SIZE=$(du -h "$BACKUP_DIR/$ARCHIVE" | cut -f1)
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] OK: $ARCHIVE ($SIZE)" | tee -a "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: backup failed" | tee -a "$LOG_FILE"
    exit 1
fi

# Rotação: apaga os backups mais velhos, ficando só com os MAX_BACKUPS mais recentes
cd "$BACKUP_DIR" && ls -t backup_*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm --
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup finished." | tee -a "$LOG_FILE"