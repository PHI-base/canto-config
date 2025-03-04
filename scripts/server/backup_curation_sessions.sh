#!/bin/sh

backup_dir=$1
encrypted_dir=$2

# Change directory to the location of the script file:
# The script file should be in the canto_space directory
canto_dir="$(dirname "$(readlink -f -- "$0")")"

# Default directories for backup and encrypted files
backup_dir=${backup_dir:="$canto_dir/backup"}
encrypted_dir=${encrypted_dir:="$backup_dir/encrypted"}

# Temporary directory for making sqlite backups
sql_export_dir="$canto_dir/import_export/sql_backup"

# Run sqlite3 through the Canto Docker container
sqlite3_cmd="$canto_dir/canto/script/canto_docker --non-interactive sqlite3"

# Use ISO 8601 basic format for dates, with UTC+0 timezone
date_str=$(date --utc "+%Y%m%dT%H%M%SZ")

backup_name="canto_backup_$date_str.tar.gz"
backup_path="$backup_dir/$backup_name"
encrypted_path="$encrypted_dir/$backup_name.gpg"
recipients_path="$canto_dir/recipients.txt"

if [ ! -d "$backup_dir" ]; then
  echo "backup directory not found at $backup_dir"
  exit 1
fi

cd "$canto_dir" || exit

# Sanity check
if [ "$(basename "$PWD")" != "canto_space" ]; then
  echo "not in canto_space directory"
  exit 1
fi

if [ ! -d ./data ]; then
  echo "Data directory not found at data/"
  exit 1
fi

if [ ! -d "$sql_export_dir" ]; then
  mkdir "$sql_export_dir" || exit
fi

cd ./data || exit

for i in *.sqlite3; do
  (cd "$canto_dir" || exit;
  $sqlite3_cmd "/data/$i" ".backup '/import_export/sql_backup/$i'");
done

cd "$canto_dir" || exit

tar -cf - -C "$sql_export_dir" . | gzip -9 > "$backup_path"

# Create encrypted backups if the email addresses of any recipients
# are specified in recipients.txt
if [ -f "$recipients_path" ]; then
  if [ ! -d "$encrypted_dir" ]; then
    mkdir "$encrypted_dir"
  fi

  recipients=""

  while IFS= read -r email; do
      recipients="$recipients --recipient $email"
  done < "$recipients_path"
  
  gpg --encrypt --output "$encrypted_path" $recipients "$backup_path"
  rm "$backup_path"
fi

# Remove temporary backup files
rm "$sql_export_dir"/*
