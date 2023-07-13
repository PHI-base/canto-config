#!/bin/sh

script="$(cat ~/script/export_session_strains.pl)"

cd /var/canto_space || exit

printf "%s\t%s\t%s\t%s\n" \
  "curation_session" "taxon_id" "strain_name" "strain_status"

./canto/script/canto_docker ./script/canto_curs_map.pl "$script"
