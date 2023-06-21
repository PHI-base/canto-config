#!/bin/sh

cd /var/canto_space/canto || exit 1

# Enable demo mode
sed -i "s/^demo_mode: 0/demo_mode: 1/" canto_deploy.yaml

# Enable demo background
if ! grep -q "^extra_css: /static/css/demo_style.css" canto_deploy.yaml; then
  sed -i "\|^demo_mode: 1|a extra_css: /static/css/demo_style.css" canto_deploy.yaml
fi
