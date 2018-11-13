#!/bin/sh

cd /var/canto_space/

./canto/script/canto_docker ./script/canto_load.pl \
--process-extension-config \
--ontology http://snapshot.geneontology.org/ontology/go-basic.obo \
--ontology https://curation.pombase.org/ontologies/PSI-MOD-2016-01-19.obo \
--ontology https://raw.githubusercontent.com/pombase/fypo/master/peco.obo \
--ontology /canto/etc/ro.obo \
--ontology https://raw.githubusercontent.com/PHI-base/phipo/b00c3cbd463c956b159ce8967cc23b8cdf873dd3/phipo.obo \
--ontology http://data.bioontology.org/ontologies/BTO/submissions/33/download?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb \
--ontology /import_export/phipo_extension_relations.obo
