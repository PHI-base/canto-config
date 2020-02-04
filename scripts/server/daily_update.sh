#!/bin/sh

cd /var/canto_space || exit 1

sh update_go_config.sh
sh load_ontologies.sh
