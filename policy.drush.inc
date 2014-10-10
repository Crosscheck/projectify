<?php

/**
 * Implement of drush_hook_COMMAND_validate().
 *
 * Prevent catastrophic braino. Note that this file has to be local to the machine
 * that intitiates sql-sync command.
 */
function drush_policy_sql_sync_validate($source = NULL, $destination = NULL) {
  if ($destination == '@SITE_NAME.prod' || $destination == '@SITE_NAME.preprod') {
    return drush_set_error(dt('Per examples/policy.drush.inc, you may never overwrite the production database.'));
  }

  if ($source == '@SITE_NAME.local') {
    return drush_set_error(dt('Per examples/policy.drush.inc, you may never push your local database.'));
  }
}
