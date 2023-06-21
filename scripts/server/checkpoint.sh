#!/bin/sh

filename=$1

cd /var/canto_space || exit

tar czf "backup/$filename.tar.gz" data/
