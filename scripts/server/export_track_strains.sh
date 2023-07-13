#!/bin/sh

cd ~ || exit

sqlite3 -header -separator '    ' /var/canto_space/data/track.sqlite3 "$(cat select_strains.sql)"
