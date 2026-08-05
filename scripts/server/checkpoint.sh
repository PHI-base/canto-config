#!/bin/sh

# Script to make a quick backup of the Canto data directory,
# to allow a rollback in case of problems.

filename=$1

cd /var/canto_space || exit

tar czf "backup/$filename.tar.gz" data/
