#!/bin/sh

cd /var/canto_space || exit 1

./canto/script/canto_docker /canto/script/canto_curs_map.pl 'use Canto::Curs::ServiceUtils; my $service = Canto::Curs::ServiceUtils->new(curs_schema => $curs_schema, config => $config); my @strains = $service->_get_strains(); for my $strain (@strains) { print $curs->curs_key(), "\t", $strain->{taxon_id}, "\t", $strain->{strain_name}, "\t", ($strain->{strain_id} ? "EXISTING" : "NEW"), "\n"; }' > export/strain_export.tsv
