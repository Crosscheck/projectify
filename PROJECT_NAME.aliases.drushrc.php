<?php

/**
 * @file
 * Drush aliases for Eandis.
 *
 * This file allows you to target both your local installation and the remote
 * environments with drush.
 *
 * Installation:
 *
 * - Copy this file to your ~/.drush directory.
 * - Edit the local alias and change the root value so it points to the drupal
 *   directory of your local version (e.g. replace
 *   '/path/to/local/eandis_2014/docroot' by your path).
 *
 * Usage:
 *
 * drush @eandis.[env] [command]
 *
 * Replace [env] by the environment to target (acc, staging, prod or local).
 *
 * Example:
 *
 * drush @wvl.dev cc all
 *
 * Clears the cache on the remote dev site.
 *
 */

$aliases['local'] = array(
  'root' => '/var/www/site/docroot/',
  'uri' => 'SITE_HOST',
);
