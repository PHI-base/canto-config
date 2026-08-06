#! /bin/sh

# Change to directory of the current script file
cd "$(dirname "$(readlink -f -- "$0")")" || exit

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/phibase_config
git -C "config" pull
