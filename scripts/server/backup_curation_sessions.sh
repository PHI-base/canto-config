#!/bin/sh

backup_dir=""
backup_path=""

while [ $# -gt 0 ]; do
    case "$1" in
        --backup-dir)
            [ -n "$2" ] || {
                echo "--backup-dir requires a value" >&2
                exit 1
            }
            backup_dir=$2
            shift 2
            ;;
        --backup-path)
            [ -n "$2" ] || {
                echo "--backup-path requires a value" >&2
                exit 1
            }
            backup_path=$2
            shift 2
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

# Get directory of the script file: should be canto_space
canto_dir="$(dirname "$(readlink -f -- "$0")")"

# Default directory for backup
default_backup_dir="$canto_dir/backup"

if [ -n "$backup_path" ] && [ -n "$backup_dir" ]; then
    echo "Cannot specify both --backup-dir and --backup-path" >&2
    exit 1
fi

if [ -n "$backup_path" ]; then
    parent_dir=$(dirname "$backup_path")

    if [ ! -d "$parent_dir" ]; then
        echo "directory not found at $parent_dir" >&2
        exit 1
    fi
fi

# Use ISO 8601 basic format for dates, with UTC+0 timezone
date_str=$(date --utc "+%Y%m%dT%H%M%SZ")

if [ -z "$backup_path" ]; then
    if [ -n "$backup_dir" ]; then
        target_dir="$backup_dir"
    else
        target_dir="$default_backup_dir"
    fi

    if [ ! -d "$target_dir" ]; then
        echo "backup directory not found at $target_dir" >&2
        exit 1
    fi

    backup_name="canto_backup_$date_str.tar.gz"
    backup_path="$target_dir/$backup_name"
fi

# Temporary directory for making sqlite backups
sql_export_dir="$canto_dir/import_export/sql_backup"

# Run sqlite3 through the Canto Docker container
sqlite3_cmd="$canto_dir/canto/script/canto_docker --non-interactive sqlite3"

cd "$canto_dir" || exit

# Sanity check
if [ "$(basename "$PWD")" != "canto_space" ]; then
    echo "not in canto_space directory" >&2
    exit 1
fi

if [ ! -d ./data ]; then
    echo "Data directory not found at data/" >&2
    exit 1
fi

if [ ! -d "$sql_export_dir" ]; then
    mkdir "$sql_export_dir" || exit
fi

cd ./data || exit

for i in *.sqlite3; do
    (
        cd "$canto_dir" || exit
        $sqlite3_cmd "/data/$i" ".backup '/import_export/sql_backup/$i'"
    ) || {
        echo "Failed to back up $i" >&2
    }
done

cd "$canto_dir" || exit

tar -cf - -C "$sql_export_dir" . | gzip -9 > "$backup_path" || exit 1

# Remove temporary files
find "$sql_export_dir" -type f -delete
