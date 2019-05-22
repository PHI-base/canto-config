#!/bin/sh

cd /var/canto_space/

./canto/script/canto_docker ./script/canto_load.pl \
--process-extension-config \
--ontology http://snapshot.geneontology.org/ontology/go-basic.obo \
--ontology https://curation.pombase.org/ontologies/PSI-MOD-2016-01-19.obo \
--ontology /import_export/phi-eco.obo \
--ontology /canto/etc/ro.obo \
--ontology http://purl.obolibrary.org/obo/phipo/phipo-simple.obo \
--ontology /import_export/BrendaTissue.obo \
--ontology /import_export/phipo_extension_relations.obo \
--ontology https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/has_qualifier_range.obo \
--ontology https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/fypo_extension.obo \
--ontology /import_export/phipo_namespace_destroyer.obo \
--ontology /import_export/phido.obo
