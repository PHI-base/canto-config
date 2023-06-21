#!/bin/sh

cd /var/canto_space/ || exit 1

./canto/script/canto_docker /canto/etc/upgrade_db.pl "$1"
