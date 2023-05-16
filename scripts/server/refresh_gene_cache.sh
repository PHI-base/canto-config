#!/bin/sh

cd /var/canto_space/ || exit 1

./canto/script/canto_docker /canto/script/canto_admin.pl --refresh-gene-cache
