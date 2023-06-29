#!/bin/sh

github_url="https://raw.githubusercontent.com/pombase/pombase-config/master/canto/annotation_ex_config"
destination="/var/canto_space/import_export"

if [ ! -d "${destination}" ]; then
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

download "${github_url}/GO_BP_A_E_config" /tmp/GO_BP_A_E_config.tsv
download "${github_url}/GO_CC_A_E_config" /tmp/GO_CC_A_E_config.tsv
download "${github_url}/GO_MF_A_E_config" /tmp/GO_MF_A_E_config.tsv
download "${github_url}/PSI-MOD_A_E_config" /tmp/PSI-MOD_A_E_config.tsv
download "${github_url}/PomGeneEx_A_E_config" PomGeneEx_A_E_config.tsv

mv /tmp/GO_BP_A_E_config.tsv ${destination}
mv /tmp/GO_CC_A_E_config.tsv ${destination}
mv /tmp/GO_MF_A_E_config.tsv ${destination}
mv /tmp/PSI-MOD_A_E_config.tsv ${destination}
mv /tmp/PomGeneEx_A_E_config.tsv" ${destination}
