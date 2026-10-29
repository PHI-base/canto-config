#!/bin/sh

backup_dir=$1
encrypted_dir=$2

# Get directory of the script file: should be canto_space
canto_dir="$(dirname "$(readlink -f -- "$0")")"

backup_dir=${backup_dir:="$canto_dir/backup"}
encrypted_dir=${encrypted_dir:="$backup_dir/encrypted"}

cd "$canto_dir" || exit 1

mkdir -p "$backup_dir"

# Use ISO 8601 basic format for dates, with UTC+0 timezone
date_str=$(date --utc "+%Y%m%dT%H%M%SZ")

backup_name="canto_backup_$date_str.tar.gz"
backup_path="$backup_dir/$backup_name"

./backup_curation_sessions.sh --backup-path "$backup_path" &&
./encrypt_curation_sessions.sh "$backup_path" "$encrypted_dir" &&
rm -f "$backup_path"  # Remove un-encrypted backup file
