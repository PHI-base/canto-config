#!/bin/sh

cd /var/canto_space/

./canto/script/canto_docker ./script/canto_load.pl \
--ontology http://snapshot.geneontology.org/ontology/go-basic.obo \
--ontology https://curation.pombase.org/ontologies/fypo/latest/fypo-simple.obo \
--ontology https://curation.pombase.org/ontologies/PSI-MOD-2016-01-19.obo \
--ontology https://raw.githubusercontent.com/pombase/fypo/master/peco.obo \
--ontology https://raw.githubusercontent.com/PHI-base/phipo/b00c3cbd463c956b159ce8967cc23b8cdf873dd3/phipo.obo
