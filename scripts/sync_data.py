#!/usr/bin/env python3

"""Synchronize strains and species with the PHI-base/data repository

This script fetches the PHI-Canto strain and species lists (currently stored
as CSV files) from the PHI-base/data repository on GitHub, and copies the
file contents to the PHI-base/canto-config repository. The columns of the 
files are renamed to match the names used by the PHI-base/canto-config 
repository.

Note that this script will change directory to the directory containing this
script file, then it will change to the data directory. This script expects
to be located in the 'scripts' directory of PHI-base/canto-config, relative
to the root directory of the repository (see the cd_to_data_dir function).
"""

__author__ = "James Seager"
__copyright__ = "Copyright (C) 2023 James Seager"
__email__ = "james.seager@rothamsted.ac.uk"
__license__ = "GNU GPLv3"
__version__ = "1.1"

import csv
import os
import urllib.request


def cd_to_data_dir():
    script_path = os.path.abspath(__file__)
    script_dir = os.path.dirname(script_path)
    dir_name = os.path.basename(script_dir)
    if dir_name != "scripts":
        raise FileNotFoundError('Not in the scripts directory')
    data_dir = os.path.join(script_dir, '..', 'data')
    os.chdir(data_dir)


def get_csv_reader_from_url(url, fieldnames=None):
    response = urllib.request.urlopen(url)
    lines = (line.decode('utf-8') for line in response.readlines())
    reader = csv.DictReader(lines, fieldnames)
    return reader


def get_strain_rows(reader):
    column_mapping = {
        'ncbi_taxid': 'NcbiTaxSpeciesId',
        'scientific_name': 'ScientificName',
        'strain': 'Strain',
        'synonyms': 'Synonyms',
    }
    return [
        {
            column_mapping[k]: v.strip()
            for k, v in row.items()
            if k != 'cross_references'
        }
        for row in reader
    ]


def get_species_rows(reader, fieldnames):
    return [{col: row[col] for col in fieldnames} for row in reader]


def write_csv(rows, path, fieldnames, include_header=True):
    dialect = csv.unix_dialect()
    dialect.quoting = csv.QUOTE_MINIMAL
    with open(path, 'w', encoding='utf-8') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames, dialect=dialect)
        if include_header:
            writer.writeheader()
        writer.writerows(rows)


def make_strain_csv(url, path):
    get_species_and_strain = lambda row: (row['ScientificName'], row['Strain'].lower())
    fieldnames = ['NcbiTaxSpeciesId', 'ScientificName', 'Strain', 'Synonyms']
    reader = get_csv_reader_from_url(url)
    rows = get_strain_rows(reader)
    sorted_rows = sorted(rows, key=get_species_and_strain)
    write_csv(sorted_rows, path, fieldnames)


def make_species_csv(url, path):
    fieldnames_out = ['scientific_name', 'ncbi_taxid', 'common_name']
    reader = get_csv_reader_from_url(url)
    rows = get_species_rows(reader, fieldnames_out)
    sorted_rows = sorted(rows, key=lambda row: row['scientific_name'])
    write_csv(sorted_rows, path, fieldnames_out, include_header=False)


if __name__ == '__main__':
    cd_to_data_dir()
    repo_url = 'https://raw.githubusercontent.com/PHI-base/data/master/'
    pathogen_strain_url = repo_url + 'strains/phicanto_pathogen_strains.csv'
    host_strain_url = repo_url + 'strains/phicanto_host_strains.csv'
    pathogen_species_url = repo_url + 'species/phicanto_pathogen_species.csv'
    host_species_url = repo_url + 'species/phicanto_host_species.csv'

    make_strain_csv(pathogen_strain_url, 'pathogen_strains.csv')
    make_strain_csv(host_strain_url, 'host_strains.csv')
    make_species_csv(pathogen_species_url, 'pathogen_species.csv')
    make_species_csv(host_species_url, 'host_species.csv')
