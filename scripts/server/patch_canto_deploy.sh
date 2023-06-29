#!/bin/sh

if [ $# = 0 ]; then
  echo "No deploy mode specified: pick one of 'prod', 'dev', 'test', or 'demo'."
	exit 1
fi

while [ $# -gt 0 ]; do
  arg="$1"

  case $arg in
    -m|--mode)
      mode=$2
      shift; shift ;;
    *)
      echo "Invalid option."
      exit 1 ;;
  esac
done

disable_email () {
  sed -i -r \
  -e "s/^(email:)$/# \1/" \
  -e "s/^(  *from_address:)/# \1/" \
  -e "s/^(  *admin_address:)/# \1/" \
  -e "s/^(  *noreply_address:)/# \1/" \
  -e "s/^(contact_email:)/# \1/" \
  -e "s/^(  *address:)/# \1/" \
  canto_deploy.yaml
}

disable_sponsor_logos () {
  sed -i -r \
  -e "s/^(extra_sponsors:)/# \1/" \
  -e "s/^(  *- link_url:)/# \1/g" \
  -e "s/^(  *logo_url:)/# \1/g" \
  canto_deploy.yaml
}

disable_google_analytics () {
  sed -i -r \
  -e "s/^(google_analytics_id:)/# \1/" \
  -e "s/^(google_tag_manager_id:)/# \1/" \
  canto_deploy.yaml
}

use_orcid_sandbox () {
  sed -i -r \
  -e "s/grant_uri: .+/grant_uri: 'https:\/\/sandbox.orcid.org\/oauth\/authorize'/" \
  -e "s/token_uri: .+/token_uri: 'https:\/\/sandbox.orcid.org\/oauth\/token'/" \
  canto_deploy.yaml
}

add_oauth_credentials () {
  if [ -f ../oauth_client_id ]; then
    client_id="$(cat ../oauth_client_id)"
  else
    echo "warning: OAuth client id not found in file oauth_client_id."
    return 1
  fi
  if [ -f ../oauth_client_secret ]; then
    client_secret="$(cat ../oauth_client_secret)"
  else
    echo "warning: OAuth client secret not found in file oauth_client_secret."
    return 1
  fi
  sed -i -r \
  -e "s/^(  *)client_id: .+/\1client_id: '$client_id'/" \
  -e "s/^(  *)client_secret: .+/\1client_secret: '$client_secret'/" \
  canto_deploy.yaml
}

enable_demo_mode () {
  sed -i "s/^demo_mode: 0/demo_mode: 1/" canto_deploy.yaml
  if ! grep -q "^extra_css: /static/css/demo_style.css" canto_deploy.yaml; then
    sed -i "\|^demo_mode: 1|a extra_css: /static/css/demo_style.css" canto_deploy.yaml
  fi
}

# Change to directory of the current script file
cd "$(dirname "$(readlink -f -- "$0")")" || exit 1
cd canto

case $mode in
  prod|production)
    # Don't make any changes, production is the default
  ;;
  demo)
    enable_demo_mode
  ;;
  test)
    disable_email
    disable_google_analytics
  ;;
  dev|development)
    disable_email
    disable_sponsor_logos
    disable_google_analytics
    use_orcid_sandbox
  ;;
  *)
    echo "Invalid mode. Select one of 'prod', 'dev', 'test', or 'demo'."
    exit 1
  ;;
esac

add_oauth_credentials
