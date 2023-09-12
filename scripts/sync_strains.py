#!/usr/bin/env python3

"""Synchronize strain lists with the PHI-base/data repository

This script fetches the PHI-Canto strain lists (currently stored as CSV
files) from the PHI-base/data repository on GitHub, and copies the file
contents to the PHI-base/config repository. The columns of the files are
renamed to match the names used by the PHI-base/config repository.

Note that this script will change directory to the directory containing this
script file, then it will change to the data directory. This script expects
to be located in the 'scripts' directory of PHI-base/config, relative to
the root directory of the repository (see the cd_to_data_dir function).
"""

__author__ = "James Seager"
__copyright__ = "Copyright (C) 2023 James Seager"
__email__ = "james.seager@rothamsted.ac.uk"
__license__ = "GNU GPLv3"
__version__ = "1.0"

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


def get_url_reader(url):
    response = urllib.request.urlopen(url)
    lines = (line.decode('utf-8') for line in response.readlines())
    reader = csv.DictReader(lines)
    return reader


def get_processed_rows(reader):
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


def sort_rows(rows):
    by_species_and_strain = lambda d: (d['ScientificName'], d['Strain'].lower())
    return sorted(rows, key=by_species_and_strain)


def write_csv(fieldnames, rows, path):
    dialect = csv.unix_dialect()
    dialect.quoting = csv.QUOTE_MINIMAL
    with open(path, 'w', encoding='utf-8') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames, dialect=dialect)
        writer.writeheader()
        writer.writerows(rows)


def make_strain_csv(url, path):
    fieldnames = ['NcbiTaxSpeciesId', 'ScientificName', 'Strain', 'Synonyms']
    reader = get_url_reader(url)
    rows = sort_rows(get_processed_rows(reader))
    write_csv(fieldnames, rows, path)


if __name__ == '__main__':
    cd_to_data_dir()
    repo_url = 'https://raw.githubusercontent.com/PHI-base/data/master/'
    pathogen_strain_url = repo_url + 'strains/phicanto_pathogen_strains.csv'
    host_strain_url = repo_url + 'strains/phicanto_host_strains.csv'

    make_strain_csv(pathogen_strain_url, 'pathogen_strains.csv')
    make_strain_csv(host_strain_url, 'host_strains.csv')
