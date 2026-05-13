#!/bin/sh

cd /var/canto_space/

./canto/script/canto_docker --non-interactive ./script/canto_load.pl \
--process-extension-config \
--ontology /import_export/ontologies/go-basic.obo \
--ontology /import_export/ontologies/PSI-MOD-2016-01-19.obo \
--ontology /import_export/ontologies/phi-eco.obo \
--ontology /canto/etc/ro.obo \
--ontology /import_export/ontologies/phipo-simple.obo \
--ontology /import_export/bto_isa.obo \
--ontology /import_export/phipo_extension_relations.obo \
--ontology /import_export/ontologies/phipo_ext.obo \
--ontology /import_export/ontologies/has_qualifier_range.obo \
--ontology /import_export/ontologies/fypo_extension.obo \
--ontology /import_export/ontologies/pombase_gene_expression_ontology.obo \
--ontology /import_export/ontologies/chebi.obo \
--ontology /import_export/ontologies/phido.obo \
--ontology /import_export/ontologies/so-simple.obo
