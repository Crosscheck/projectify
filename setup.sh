#!/usr/bin/env bash
#
# Build the site locally. This will remove your current build!
#

# Configuration

# The repository name.
# Ex. git.dotprojects.be:PROJECT_NAME.git
repo_name=PROJECT_NAME

# The short name used for your project. This is used for:
# - site directory
# - alias prefix
# - database name
site_name=SITE_NAME

# The site hostname to be used by Mamp / Vagrant
# and to be added to your local Hosts file.
# Ex. SITE_NAME.local
site_host=SITE_HOST

# Determine local path.
local_path="${PWD}/${repo_name}"
initial_path=$PWD

# Clone the repository locally.
git clone git@gitlab.crosscheck.be:crosscheck/${repo_name} -b production $PWD

if [[ -d $local_path ]];
then
  # Read the local configuration.
  read -p "Local database name (default: ${site_name}): " db_name;
  read -p "Local database user (default: root): " db_user;
  read -p "Local database password (default: root): " db_password;
  read -p "Local host name (default: ${site_name}.local): " site_host;

  # Create drush alias file.
  cp "${local_path}/scripts/${site_name}.aliases.drushrc.php" ~/.drush/${site_name}.aliases.drushrc.php
  sed -i '' "s|/path/to/local/${site_name}/docroot|${local_path}/docroot|" ~/.drush/${site_name}.aliases.drushrc.php;

  if [[ -n $site_host ]];
  then
    sed -i '' "s|${site_name}.local|${site_host}|" "${local_path}/docroot/sites/local.sites.php"
    sed -i '' "s|${site_name}.local|${site_host}|" ~/.drush/${site_name}.aliases.drushrc.php;
  fi

  # Add the Drush policy to our local drush installation.
  cp "${local_path}/scripts/policy.drush.inc" ~/.drush/policy.drush.inc


  # Create the local configuration files.
  cp "${local_path}/docroot/sites/${site_name}/example.local.settings.php" "${local_path}/docroot/sites/${site_name}/local.settings.php"
  cp "${local_path}/docroot/sites/example.local.sites.php" "${local_path}/docroot/sites/local.sites.php"

  # Override the local configuration with the user entered values.
  if [[ -n $db_name ]];
  then
    sed -i '' "s|\'database\' => \'${site_name}\'|\'database\' => \'${db_name}\'|" "${local_path}/docroot/sites/${site_name}/local.settings.php"
  fi

  if [[ -n $db_user ]];
  then
    sed -i '' "s|\'username\' => \'root\'|\'username\' => \'${db_user}\'|" "${local_path}/docroot/sites/${site_name}/local.settings.php"
  fi

  if [[ -n $db_password ]];
  then
    sed -i '' "s|\'password\' => \'root\'|\'password\' => \'${db_password}\'|" "${local_path}/docroot/sites/${site_name}/local.settings.php"
  fi

  if [[ -n $site_host ]];
  then
    sed -i '' "s|${site_name}.local|${site_host}|" "${local_path}/docroot/sites/local.sites.php"
  fi

  # Do a clean install
  cd "${local_path}/docroot"
  drush site-install ${site_name} -y --sites-subdir="${site_name}" --account-name=admin --account-pass=admin --account-mail=support@crosscheck.be --site-mail='support@crosscheck.be' --site-name='${site_name}'

  # Fix file permissions
  chmod +w sites/${site_name}
  chmod +w sites/${site_name}/settings.php

  # Set up local configuration.
  cd $local_path
  source scripts/update.sh

  cd $initial_path

  echo "The site has been installed in the following path:"
  echo "${local_path}/docroot"
  echo "Please create a vhost pointing the the above directory with the following host name:"
  if [[ -n $site_host ]]; then
    echo $site_host
  else
    echo "${site_name}.local"
  fi

  exit 0;
else
  echo "There was a problem cloning the git repository. Make sure your key is added to gitolite or you have proper access in Gitlab. Aborting." >&2;
  exit 1;
fi
