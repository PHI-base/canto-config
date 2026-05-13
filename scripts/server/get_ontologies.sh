#!/bin/sh

# Download ontology files from the web using wget, to try to
# stop the ontology loading script failing due to HTTP errors.

if [ ! -d "/var/canto_space/" ]; then
    echo "canto_space directory does not exist at /var/canto_space/"
    exit 1
fi

cd /var/canto_space/ || exit 1

if [ ! -d "./import_export" ]; then
    echo "import_export directory does not exist at /var/canto_space/import_export"
    exit 1
fi

mkdir -p ./import_export/ontologies || {
    echo "Failed to create ontologies directory at /var/canto_space/import_export/ontologies"
    exit 1
}

cd ./import_export/ontologies || exit 1

# List of URL and filename pairs
cat <<EOF | while read -r url filename; do
http://snapshot.geneontology.org/ontology/go-basic.obo go-basic.obo
https://curation.pombase.org/ontologies/PSI-MOD-2016-01-19.obo PSI-MOD-2016-01-19.obo
https://raw.githubusercontent.com/PHI-base/phi-eco/master/phi-eco.obo phi-eco.obo
http://purl.obolibrary.org/obo/phipo/phipo-simple.obo phipo-simple.obo
https://raw.githubusercontent.com/PHI-base/phipo_ext/master/phipo_ext.obo phipo_ext.obo
https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/has_qualifier_range.obo has_qualifier_range.obo
https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/fypo_extension.obo fypo_extension.obo
https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/pombase_gene_expression_ontology.obo pombase_gene_expression_ontology.obo
https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/chebi.obo chebi.obo
https://raw.githubusercontent.com/PHI-base/phido/master/phido.obo phido.obo
http://purl.obolibrary.org/obo/so/so-simple.obo so-simple.obo
EOF

    if ! wget -q -O "$filename" "$url"; then
        echo "Warning: Failed to download $filename from $url"
    fi
done
