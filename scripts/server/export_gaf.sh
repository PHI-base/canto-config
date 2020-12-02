#!/bin/sh

export_dir=./export
gaf_path=$export_dir/phibase.gaf
export_cmd="./canto/script/canto_docker --non-interactive /canto/script/canto_export.pl gaf --dump-approved"

cd /var/canto_space || exit

# Create export directory if it doesn't exist
if ! mkdir -p $export_dir
then
  echo "Couldn't make export directory. Exiting."
  exit 1
fi

# Create GAF file if it doesn't exist
if [ ! -e $gaf_path ]; then
  touch $gaf_path
fi

# Add header comments, overwriting old GAF file contents
cat <<EOT > $gaf_path
!gaf-version: 2.1
!Project_name: PHI-base
!URL: http://www.phi-base.org/
!Contact Email: contact@phi-base.org
EOT

# Append annotations for each GO annotation type
{
  $export_cmd --annotation-type=biological_process
  $export_cmd --annotation-type=cellular_component
  $export_cmd --annotation-type=molecular_function
} >> $gaf_path

# Remove trailing newlines from appending the files
sed -i '/^$/d' $gaf_path
