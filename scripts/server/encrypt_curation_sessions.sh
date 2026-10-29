#!/bin/sh

backup_path=$1
encrypted_dir=$2

[ -n "$backup_path" ] || {
    echo "backup path required" >&2
    exit 1
}
[ -f "$backup_path" ] || {
    echo "backup file not found at $backup_path" >&2
    exit 1
}

# Get directory of the script file: should be canto_space
canto_dir="$(dirname "$(readlink -f -- "$0")")"

# Default directories for backup and encrypted files
backup_dir="$canto_dir/backup"
encrypted_dir=${encrypted_dir:="$backup_dir/encrypted"}

backup_name=$(basename "$backup_path")
encrypted_path="$encrypted_dir/$backup_name.gpg"
recipients_path="$canto_dir/recipients.txt"

if [ ! -f "$recipients_path" ]; then
    echo "No recipients file found at $recipients_path" >&2
    exit 1
fi

# Create encrypted backups if the email addresses of any recipients
# are specified in recipients.txt
if [ ! -d "$encrypted_dir" ]; then
    mkdir -p "$encrypted_dir"
fi

recipients=""

while IFS= read -r email; do
    [ -n "$email" ] || continue  # Skip blank lines
    recipients="$recipients --recipient $email"
done < "$recipients_path"

if [ -z "$recipients" ]; then
    echo "No recipients configured in $recipients_path" >&2
    exit 1
fi

gpg --encrypt --output "$encrypted_path" $recipients "$backup_path" || exit 1
