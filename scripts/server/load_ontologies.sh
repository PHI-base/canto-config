#!/bin/sh

cd /var/canto_space/

./canto/script/canto_docker --non-interactive ./script/canto_load.pl \
--process-extension-config \
--ontology http://snapshot.geneontology.org/ontology/go-basic.obo \
--ontology https://curation.pombase.org/ontologies/PSI-MOD-2016-01-19.obo \
--ontology https://raw.githubusercontent.com/PHI-base/phi-eco/master/phi-eco.obo \
--ontology /canto/etc/ro.obo \
--ontology http://purl.obolibrary.org/obo/phipo/phipo-simple.obo \
--ontology /import_export/bto_isa.obo \
--ontology /import_export/phipo_extension_relations.obo \
--ontology /import_export/phipo_ext.obo \
--ontology https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/has_qualifier_range.obo \
--ontology https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/fypo_extension.obo \
--ontology https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/pombase_gene_expression_ontology.obo \
--ontology https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/chebi.obo \
--ontology /import_export/phipo_namespace_destroyer.obo \
--ontology https://raw.githubusercontent.com/PHI-base/phido/master/phido.obo \
--ontology http://purl.obolibrary.org/obo/so/so-simple.obo
