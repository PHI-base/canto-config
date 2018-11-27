#!/bin/sh

cd /var/canto_space/

./canto/script/canto_docker ./script/canto_load.pl \
--ontology http://snapshot.geneontology.org/ontology/go-basic.obo \
--ontology https://curation.pombase.org/ontologies/PSI-MOD-2016-01-19.obo \
--ontology /import_export/phi-eco.obo \
--ontology /canto/etc/ro.obo \
--ontology https://raw.githubusercontent.com/PHI-base/phipo/a87351db4b07c4b21906cab1ef460148cf5889bc/phipo.obo
