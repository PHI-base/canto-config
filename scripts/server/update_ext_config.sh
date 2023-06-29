#!/bin/sh

# Change to directory of the current script file
cd "$(dirname "$(readlink -f -- "$0")")" || exit

github_url="https://raw.githubusercontent.com/pombase/pombase-config/master/canto/annotation_ex_config"
destination="./import_export"

if [ ! -d "$destination" ]; then
  echo "ERROR: directory does not exist: ${destination}" 1>&2
  exit 1;
fi

download() {
    url=$1;
    path=$2;
    headers="$(wget -O "$path" -q --server-response "$url" 2>&1)"
    if ! (echo "$headers" | head -n 1 | grep -q "200"); then
      printf "ERROR: did not get status code 200 for URL:\n%s\n" "$url" 1>&2
      exit 1;
    fi
}

cd $destination

download "$github_url/GO_BP_A_E_config" GO_BP_A_E_config.tmp.tsv
download "$github_url/GO_CC_A_E_config" GO_CC_A_E_config.tmp.tsv
download "$github_url/GO_MF_A_E_config" GO_MF_A_E_config.tmp.tsv
download "$github_url/PSI-MOD_A_E_config" PSI-MOD_A_E_config.tmp.tsv
download "$github_url/PomGeneEx_A_E_config" PomGeneEx_A_E_config.tmp.tsv

mv GO_BP_A_E_config.tmp.tsv GO_BP_A_E_config.tsv
mv GO_CC_A_E_config.tmp.tsv GO_CC_A_E_config.tsv
mv GO_MF_A_E_config.tmp.tsv GO_MF_A_E_config.tsv
mv PSI-MOD_A_E_config.tmp.tsv PSI-MOD_A_E_config.tsv
mv PomGeneEx_A_E_config.tmp.tsv PomGeneEx_A_E_config.tsv
