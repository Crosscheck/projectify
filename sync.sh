#!/usr/bin/env bash
#
# Syncs the local site with production.

site_name=SITE_NAME

drush sql-sync @${site_name}.dev @${site_name}.local -y
drush rsync @${site_name}.dev:%files @${site_name}.local:%files -y
drush @${site_name}.local env-switch --force local
drush @${site_name}.local cc all
