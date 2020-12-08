#!/bin/sh

canto_dir=/var/canto_space
export_dir=/var/canto_space
export_all=false

cd $canto_dir || exit

if ! mkdir -p $export_dir
then
  >&2 echo "Can't create export directory at $export_dir"
  exit 1
fi

while [ $# -gt 0 ]; do
    arg="$1"
    case $arg in
        -a|--all)
            export_all=true
            shift
        ;;
        *)
            >&2 echo "Invalid argument: Use -a or --all"
            exit 1
        ;;
    esac
done

if [ "$export_all" = true ]; then
    export_mode="all"
else
    export_mode="approved"
fi

if [ "$export_mode" = "approved" ]; then
  approved_arg="--dump-approved"
fi

filename_base="phicanto_export"
date_str=$(date +"%Y-%m-%d")

filename="${filename_base}_${export_mode}_${date_str}.json"

./canto/script/canto_docker --non-interactive \
/canto/script/canto_export.pl canto-json "${approved_arg:-}" > "$export_dir/$filename"
