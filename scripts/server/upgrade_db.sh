#!/bin/sh

[ -n "$1" ] || {
    echo "database version argument required" >&2
    exit 1
}

cd /var/canto_space/ || exit 1

# Get directory of the script file: should be canto_space
canto_dir="$(dirname "$(readlink -f -- "$0")")"

backup_dir="$canto_dir/backup"

if [ ! -d "$backup_dir" ]; then
    echo "backup directory not found at $backup_dir" >&2
    exit 1
fi

# Use ISO 8601 basic format for dates, with UTC+0 timezone
date_str=$(date --utc "+%Y%m%dT%H%M%SZ")

./backup_curation_sessions.sh \
    --backup-path "$backup_dir/canto_backup_pre_db_v${1}_${date_str}.tar.gz" &&
./canto/script/canto_docker /canto/etc/upgrade_db.pl "$1"
