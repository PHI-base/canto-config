#!/bin/sh

cd /var/canto_space || exit 1

sh update_ext_config.sh
sh get_ontologies.sh
sh load_ontologies.sh
./canto/script/canto_docker /canto/script/canto_daily.pl https://canto.phi-base.org/
