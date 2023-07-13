#!/usr/bin/env perl

use strict;
use warnings;
use Carp;

use File::Basename;

BEGIN {
  my $script_name = basename $0;

  if (-f $script_name && -d "../etc") {
    chdir "..";
  }
};

use lib qw(lib);

use Canto::Config;
use Canto::TrackDB;
use Canto::Meta::Util;

my $app_name = Canto::Config::get_application_name();

$ENV{CANTO_CONFIG_LOCAL_SUFFIX} ||= 'deploy';

my $suffix = $ENV{CANTO_CONFIG_LOCAL_SUFFIX};

if (!Canto::Meta::Util::app_initialised($app_name, $suffix)) {
  die "The application is not yet initialised, try running the canto_start " .
    "script\n";
}

my $config = Canto::Config::get_config();
my $track_schema = Canto::TrackDB->new(config => $config);

my $target_relation = 'compared_to_control';
my $target_range_type = 'Metagenotype';

my $proc = sub {
  my $curs = shift;
  my $cursdb = shift;

  my $annotation_rs = $cursdb->resultset('Annotation');

  my %metagenotype_ids;
  my $metagenotype_id;
  my $metagenotype_rs = $cursdb->resultset('Metagenotype');
  while (defined (my $metagenotype = $metagenotype_rs->next())) {
    $metagenotype_id = $metagenotype->metagenotype_id();
    $metagenotype_ids{$metagenotype_id} = 1;
  }

  while (defined (my $annotation = $annotation_rs->next())) {
    # TODO: check if annotation is in list of valid types

    my $data = $annotation->data();
    my $extension = $data->{extension};

    my $is_valid_extension = 0;
    my $rangeValue;
    my $rangeDisplayName;

    if (defined $extension) {
      map {
        my $or_part = $_;
        map {
          my $and_part = $_;
          $is_valid_extension = (
            $and_part->{rangeType}
            && $and_part->{rangeType} eq $target_range_type
            && $and_part->{relation} eq $target_relation
          );
          if ($is_valid_extension) {
            $rangeValue = $and_part->{rangeValue};
            $rangeDisplayName = $and_part->{rangeDisplayName};
            if (! exists($metagenotype_ids{$rangeValue})) {
              print "Missing metagenotype in session ", $curs->curs_key(), ":\n";
              print "  ", $rangeDisplayName, "\n";
            }
          }
        } @$or_part;
      } @$extension;
    }
  }
};

Canto::Track::curs_map($config, $track_schema, $proc);
