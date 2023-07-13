#!/usr/bin/perl

use strict;
use open ':std', ':encoding(UTF-8)';
use feature qw(say);

use Canto::Curs::ServiceUtils;

my $service = Canto::Curs::ServiceUtils->new(
    curs_schema => $curs_schema,
    config => $config
);

my @strains = $service->_get_strains();

for my $strain (@strains) {
    say join("\t",
        $curs->curs_key(),
        $strain->{taxon_id},
        $strain->{strain_name},
        ($strain->{strain_id} ? "EXISTING" : "NEW")
    );
}
