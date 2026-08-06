#! /bin/sh

# Change to directory of the current script file
cd "$(dirname "$(readlink -f -- "$0")")" || exit

git -C "canto-config" pull
