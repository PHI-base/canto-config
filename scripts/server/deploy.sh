#!/bin/sh

update_self () {
  new_config_path="config/scripts/server/deploy.sh"
  if [ -f $new_config_path ]; then
    this_script="$0"
    if ! cmp -s $new_config_path "$this_script"; then
      cp $new_config_path "$this_script"
      sh "$this_script"
      exit 0
    fi
  fi
}

# Change to directory of the current script file
cd "$(dirname "$(readlink -f -- "$0")")" || exit 1

if [ ! -d ./config ]; then
  echo "Can't locate config directory at config/ - Aborting."
  exit 1
fi

update_self

if [ -f deploy_mode ]; then
  deploy_mode="$(cat deploy_mode)"
else
  echo "Can't find the deploy_mode file. Aborting."
  exit 1
fi

case $deploy_mode in
  prod|production|demo|dev|development|test) ;;
  *)
    echo "Invalid deployment mode. Valid modes are 'prod', 'dev', 'test', or 'demo'. Aborting."
    exit 1
  ;;
esac

cp -t ./ \
config/scripts/server/backup_curation_sessions.sh \
config/scripts/server/daily_update.sh \
config/scripts/server/export_gaf.sh \
config/scripts/server/load_ontologies.sh \
config/scripts/server/patch_canto_deploy.sh \
config/scripts/server/pull_config.sh \
config/scripts/server/update_canto.sh \
config/scripts/server/update_ext_config.sh \
config/scripts/server/upgrade_db.sh

cp -t import_export/ \
config/species_strain_map.yaml \
config/host_organism_taxon_ids.yaml \
config/data/* \
config/annotation_extension/*

cp config/canto_deploy.yaml ./canto_deploy.tmp.yaml &&
sh patch_canto_deploy.sh --mode "$deploy_mode" ./canto_deploy.tmp.yaml &&
mv ./canto_deploy.tmp.yaml ./canto/canto_deploy.yaml

rm -f ./canto_deploy.tmp.yaml

sh update_ext_config.sh
