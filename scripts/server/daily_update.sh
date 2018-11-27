#!/bin/sh

cd /var/canto_space/

cp config_canto/data/host_species.csv canto/host_species.csv
cp config_canto/data/host_strains.csv canto/host_strains.csv
cp config_canto/data/pathogen_species.csv canto/pathogen_species.csv
cp config_canto/data/pathogen_strains.csv canto/pathogen_strains.csv

./canto/script/canto_docker ./script/canto_load.pl --organisms host_species.csv
./canto/script/canto_docker ./script/canto_load.pl --strains host_strains.csv
./canto/script/canto_docker ./script/canto_load.pl --organisms pathogen_species.csv
./canto/script/canto_docker ./script/canto_load.pl --strains pathogen_strains.csv

rm canto/host_species.csv
rm canto/host_strains.csv
rm canto/pathogen_species.csv
rm canto/pathogen_strains.csv

"/var/canto_space/config_canto/scripts/server/load_ontologies.sh"
