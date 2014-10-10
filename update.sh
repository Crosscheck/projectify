#!/usr/bin/env bash
#
# Update the site locally.
#

site_name=SITE_NAME

drush @${site_name}.local cc all
drush @${site_name}.local en -y ${site_name}_core
drush @${site_name}.local updatedb --yes
drush @${site_name}.local fra --force --yes
drush @${site_name}.local baseline --yes
drush @${site_name}.local env-switch --force local
drush @${site_name}.local cc all
