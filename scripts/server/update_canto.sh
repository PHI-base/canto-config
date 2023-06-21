#!/bin/sh

service canto stop \
&& git -C /var/canto_space/canto pull \
&& /var/canto_space/upgrade_db.sh latest
service canto start
