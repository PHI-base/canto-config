#!/bin/sh

canto_data_dir="/var/canto_space/data"
sql_dump_dir="/var/canto_space/backup/sql_dumps"
archive_dir="/var/canto_space/backup"

command -v sqlite3 >/dev/null 2>&1 || {
  echo >&2 "sqlite3 is not installed. Aborting.";
  exit 1;
}

if [ ! -d $archive_dir ]; then
  mkdir $archive_dir
fi

if [ ! -d $sql_dump_dir ]; then
  mkdir $sql_dump_dir
fi

cd $canto_data_dir || exit 1

for i in *.sqlite3; do
  sqlite3 "$i" .dump > ${sql_dump_dir}/"$i".sql_dump;
done

date_str=$(date --utc "+%F_%H%M")
tar -czf ${archive_dir}/canto_"${date_str}".tar.gz $sql_dump_dir/*
