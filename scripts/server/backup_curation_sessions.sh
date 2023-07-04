#!/bin/sh

# Get container ID of Canto container
get_canto_id () {
  docker ps -a | awk '$2>"pombase/canto-base" { print $1 }'
}

# canto_dir is the directory of the current script file
canto_dir="$(dirname "$(readlink -f -- "$0")")"
backup_dir="$canto_dir/backup"
sql_export_dir="$canto_dir/import_export/sql_backup"
sql_backup_dir="$backup_dir/sql_backup"
sqlite3_cmd="docker exec -ti $(get_canto_id) sqlite3"
date_str=$(date --utc "+%F")

cd "$canto_dir" || exit

# Sanity check
if [ "$(basename "$PWD")" != "canto_space" ]; then
  echo "Not in canto_space directory."
  exit 1
fi

if [ ! -d ./data ]; then
  echo "Data directory not found at data/"
  exit 1
fi

if [ ! -d "$backup_dir" ]; then
  mkdir "$backup_dir"
fi

if [ ! -d "$sql_backup_dir" ]; then
  mkdir "$sql_backup_dir"
fi

if [ ! -d "$sql_export_dir" ]; then
  mkdir "$sql_export_dir"
fi

cd ./data || exit

for i in *.sqlite3; do
  $sqlite3_cmd "/data/$i" ".backup '/import_export/sql_backup/$i'";
done

tar -czf - -C "$sql_export_dir" . |
gzip -9 > "$sql_backup_dir/canto_$date_str.tar.gz"

# Cleanup
rm "$sql_export_dir"/*
