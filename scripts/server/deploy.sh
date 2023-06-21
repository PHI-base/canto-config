#!/bin/sh

cd /var/canto_space/ || exit 1

cp config_canto/canto_deploy.yaml canto/canto_deploy.yaml

cp config_canto/species_strain_map.yaml import_export/
cp config_canto/host_organism_taxon_ids.yaml import_export/

cp config_canto/scripts/server/load_ontologies.sh ./
cp config_canto/scripts/server/backup_curation_sessions.sh ./
cp config_canto/scripts/server/update_ext_config.sh ./
cp config_canto/scripts/server/export_gaf.sh ./

cp config_canto/data/host_species.csv import_export/
cp config_canto/data/host_strains.csv import_export/
cp config_canto/data/pathogen_species.csv import_export/
cp config_canto/data/pathogen_strains.csv import_export/

cp config_canto/annotation_extension/phipo_extension_relations.obo import_export/
cp config_canto/annotation_extension/phipo_extensions.tsv import_export/
cp config_canto/annotation_extension/phido_extensions.tsv import_export/
cp config_canto/annotation_extension/phibase_go_extensions.tsv import_export/
cp config_canto/annotation_extension/PomGeneEx_A_E_config.tsv import_export/
