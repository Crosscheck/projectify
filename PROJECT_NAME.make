; dotProjects Drush make file for a full featured modules setup
;
; Use this as a starting point, remove the modules from the list that you don't need
; DO NOT remove minimal module set ;-)
;
; Usage:
; $ drush make eandis.make /path/to/where/you/want/the/site/http

; Core version
; ------------
; Each makefile should begin by declaring the core version of Drupal that all
; projects should be compatible with.

core = 7.x

; API version
; ------------
; Every makefile needs to declare its Drush Make API version. This version of
; drush make uses API version `2`.

api = 2

; Core project
; ------------
; In order for your makefile to generate a full Drupal site, you must include
; a core project. This is usually Drupal core, but you can also specify
; alternative core projects like Pressflow. Note that makefiles included with
; install profiles *should not* include a core project.

; Drupal 7.x. Requires the `core` property to be set to 7.x.
projects[drupal][version] = 7.30

; Modules
; --------------
projects[acquia_connector][type] = "module"
projects[acquia_connector][subdir] = "contrib"

projects[acquia_purge][type] = "module"
projects[acquia_purge][subdir] = "contrib"

projects[acquia_search_multi_subs][type] = "module"
projects[acquia_search_multi_subs][subdir] = "contrib"

projects[admin_menu][type] = "module"
projects[admin_menu][subdir] = "contrib"

projects[admin_views][type] = "module"
projects[admin_views][subdir] = "contrib"

projects[backup_migrate][type] = "module"
projects[backup_migrate][subdir] = "contrib"

projects[bean][type] = "module"
projects[bean][subdir] = "contrib"

projects[better_formats][type] = "module"
projects[better_formats][subdir] = "contrib"

projects[block_class][type] = "module"
projects[block_class][subdir] = "contrib"

projects[ckeditor_link][type] = "module"
projects[ckeditor_link][subdir] = "contrib"

projects[ccl][type] = "module"
projects[ccl][subdir] = "contrib"

projects[colorbox][type] = "module"
projects[colorbox][subdir] = "contrib"

projects[context][type] = "module"
projects[context][subdir] = "contrib"

projects[crumbs][type] = "module"
projects[crumbs][subdir] = "contrib"

projects[ctools][type] = "module"
projects[ctools][subdir] = "contrib"

projects[date][type] = "module"
projects[date][subdir] = "contrib"

projects[devel][type] = "module"
projects[devel][subdir] = "contrib"

projects[devel_themer][type] = "module"
projects[devel_themer][subdir] = "contrib"
projects[devel_themer][download][type] = git
projects[devel_themer][download][revision] = bec0859
projects[devel_themer][download][branch] = 7.x-1.x

projects[diff][type] = "module"
projects[diff][subdir] = "contrib"

projects[ds][type] = "module"
projects[ds][subdir] = "contrib"

projects[elysia_cron][type] = "module"
projects[elysia_cron][subdir] = "contrib"

projects[email][type] = "module"
projects[email][subdir] = "contrib"

projects[entity][type] = "module"
projects[entity][subdir] = "contrib"

projects[entityreference][type] = "module"
projects[entityreference][subdir] = "contrib"

projects[entityreference_view_widget][type] = "module"
projects[entityreference_view_widget][subdir] = "contrib"
projects[entityreference_view_widget][version] = "7.x-2.0-rc1+3-dev"

projects[environment][type] = "module"
projects[environment][subdir] = "contrib"
projects[environment][download][type] = git
projects[environment][download][revision] = 6587eb6cf125a3393cbd68d11200b94948df2dbb
projects[environment][download][branch] = 7.x-1.x

projects[environment_indicator][type] = "module"
projects[environment_indicator][subdir] = "contrib"

projects[epsacrop][type] = "module"
projects[epsacrop][subdir] = "contrib"
projects[epsacrop][version] = "2.x-dev"

projects[eu_cookie_compliance][type] = "module"
projects[eu_cookie_compliance][subdir] = "contrib"

projects[expire][type] = "module"
projects[expire][subdir] = "contrib"

projects[facetapi][type] = "module"
projects[facetapi][subdir] = "contrib"

projects[facetapi_select][type] = "module"
projects[facetapi_select][subdir] = "contrib"

projects[features][type] = "module"
projects[features][subdir] = "contrib"
projects[features][version] = "2.0"

projects[features_extra][type] = "module"
projects[features_extra][subdir] = "contrib"

projects[fences][type] = "module"
projects[fences][subdir] = "contrib"

projects[field_group][type] = "module"
projects[field_group][subdir] = "contrib"

projects[file_entity][type] = "module"
projects[file_entity][subdir] = "contrib"
projects[file_entity][download][type] = git
projects[file_entity][download][revision] = 75fa843
projects[file_entity][download][branch] = 7.x-2.x

projects[globalredirect][type] = "module"
projects[globalredirect][subdir] = "contrib"

projects[google_tag][type] = "module"
projects[google_tag][subdir] = "contrib"

projects[i18n][type] = "module"
projects[i18n][subdir] = "contrib"

projects[jquery_update][type] = "module"
projects[jquery_update][subdir] = "contrib"

projects[l10n_update][type] = "module"
projects[l10n_update][subdir] = "contrib"
projects[l10n_update][download][type] = git
projects[l10n_update][download][revision] = 20a80d1
projects[l10n_update][download][branch] = 7.x-1.x

projects[libraries][type] = "module"
projects[libraries][subdir] = "contrib"

projects[link][type] = "module"
projects[link][subdir] = "contrib"

projects[media][type] = "module"
projects[media][subdir] = "contrib"
projects[media][download][type] = git
projects[media][download][revision] = fe09f09
projects[media][download][branch] = 7.x-2.x

projects[menu_attributes][type] = "module"
projects[menu_attributes][subdir] = "contrib"

projects[menu_block][type] = "module"
projects[menu_block][subdir] = "contrib"

projects[menu_position][type] = "module"
projects[menu_position][subdir] = "contrib"

projects[metatag][type] = "module"
projects[metatag][subdir] = "contrib"
projects[metatag][version] = "7.x-1.0+3-dev"

projects[migrate][type] = "module"
projects[migrate][subdir] = "contrib"

projects[migrate_extras][type] = "module"
projects[migrate_extras][subdir] = "contrib"

projects[module_filter][type] = "module"
projects[module_filter][subdir] = "contrib"

projects[nodequeue][type] = "module"
projects[nodequeue][subdir] = "contrib"

projects[panelizer][type] = "module"
projects[panelizer][subdir] = "contrib"

projects[panels][type] = "module"
projects[panels][subdir] = "contrib"

projects[panels_breadcrumbs][type] = "module"
projects[panels_breadcrumbs][subdir] = "contrib"

projects[password_policy][type] = "module"
projects[password_policy][subdir] = "contrib"

projects[pathauto][type] = "module"
projects[pathauto][subdir] = "contrib"

projects[publishcontent][type] = "module"
projects[publishcontent][subdir] = "contrib"

projects[rabbit_hole][type] = "module"
projects[rabbit_hole][subdir] = "contrib"

projects[redirect][type] = "module"
projects[redirect][subdir] = "contrib"
projects[redirect][version] = "1.x-dev"

projects[rules][type] = "module"
projects[rules][subdir] = "contrib"

projects[scheduler][type] = "module"
projects[scheduler][subdir] = "contrib"

projects[search_api][type] = "module"
projects[search_api][subdir] = "contrib"

projects[search_api_acquia][type] = "module"
projects[search_api_acquia][subdir] = "contrib"

projects[search_api_attachments][type] = "module"
projects[search_api_attachments][subdir] = "contrib"

projects[search_api_solr][type] = "module"
projects[search_api_solr][subdir] = "contrib"

projects[search_api_sorts][type] = "module"
projects[search_api_sorts][subdir] = "contrib"

projects[securepages][type] = "module"
projects[securepages][subdir] = "contrib"

projects[seckit][type] = "module"
projects[seckit][subdir] = "contrib"

projects[semanticviews][type] = "module"
projects[semanticviews][subdir] = "contrib"

projects[shield][type] = "module"
projects[shield][subdir] = "contrib"

projects[shortcode][type] = "module"
projects[shortcode][subdir] = "contrib"

projects[smart_trim][type] = "module"
projects[smart_trim][subdir] = "contrib"

projects[smartqueue_language][type] = "module"
projects[smartqueue_language][subdir] = "contrib"

projects[special_menu_items][type] = "module"
projects[special_menu_items][subdir] = "contrib"

projects[strongarm][type] = "module"
projects[strongarm][subdir] = "contrib"

projects[title][type] = "module"
projects[title][subdir] = "contrib"

projects[token][type] = "module"
projects[token][subdir] = "contrib"

projects[transliteration][type] = "module"
projects[transliteration][subdir] = "contrib"

projects[username_enumeration_prevention][type] = "module"
projects[username_enumeration_prevention][subdir] = "contrib"

projects[variable][type] = "module"
projects[variable][subdir] = "contrib"

projects[views][type] = "module"
projects[views][subdir] = "contrib"

projects[views_bulk_operations][type] = "module"
projects[views_bulk_operations][subdir] = "contrib"

projects[views_litepager][type] = "module"
projects[views_litepager][subdir] = "contrib"

projects[webform][type] = "module"
projects[webform][subdir] = "contrib"

projects[wysiwyg][type] = "module"
projects[wysiwyg][subdir] = "contrib"
projects[wysiwyg][download][type] = git
projects[wysiwyg][download][revision] = ee64524
projects[wysiwyg][download][branch] = 7.x-2.x

projects[xmlsitemap][type] = "module"
projects[xmlsitemap][subdir] = "contrib"


; Themes
; --------------

projects[omega][version] = "4.2"
projects[omega][type] = "theme"
projects[omega][subdir] = "contrib"

; Custom modules
; --------------

projects[baseline][type] = "module"
projects[baseline][subdir] = "custom"
projects[baseline][download][type] = git
projects[baseline][download][url] = "git://github.com/Crosscheck/baseline.git"
projects[baseline][download][revision] = d19f5f243ddd66be9c335b3f9b390a78b2474313
projects[baseline][download][branch] = master

projects[baseline_content][type] = "module"
projects[baseline_content][subdir] = "custom"
projects[baseline_content][download][type] = git
projects[baseline_content][download][url] = "git://github.com/Crosscheck/baseline_content.git"
projects[baseline_content][download][revision] = 79af18f
projects[baseline_content][download][branch] = master


; Libraries
; --------------

libraries[ckeditor][type] = "libraries"
libraries[ckeditor][download][type] = "file"
libraries[ckeditor][download][url] = "http://download.cksource.com/CKEditor/CKEditor/CKEditor%204.3.2/ckeditor_4.3.2_full.zip"

libraries[selectivizr][download][type] = "file"
libraries[selectivizr][download][url] = "https://github.com/fubhy/selectivizr/archive/master.zip"

libraries[html5shiv][download][type] = "file"
libraries[html5shiv][download][url] = "https://github.com/fubhy/html5shiv/archive/master.zip"

libraries[respond][download][type] = "file"
libraries[respond][download][url] = "https://github.com/fubhy/respond/archive/master.zip"

libraries[matchmedia][download][type] = "file"
libraries[matchmedia][download][url] = "https://github.com/fubhy/matchmedia/archive/master.zip"

libraries[pie][download][type] = "file"
libraries[pie][download][url] = "https://github.com/fubhy/pie/archive/master.zip"

libraries[Jcrop][download][type] = "file"
libraries[Jcrop][download][url] = "https://github.com/tapmodo/Jcrop/archive/master.zip"

libraries[json2][download][type] = "file"
libraries[json2][download][url] = "https://github.com/douglascrockford/JSON-js/archive/master.zip"


; Patches
;--------
projects[drupal][patch][] = "http://drupal.org/files/issues/allow-shortcut-query-parameters-614498-22.patch"
projects[drupal][patch][] = "http://drupal.org/files/issues/create-directory-on-file-copy-2211657-7.patch"
projects[drupal][patch][] = "https://www.drupal.org/files/1673794-unpublished-access-to-translations.patch"

projects[crumbs][patch][] = "../patches/crumbs_route_undefined_index.patch"
projects[ctools][patch][] = "https://www.drupal.org/files/issues/ctools-n2195211-entity-from-field-access-callback-15.patch"
projects[ds][patch][] = "http://drupal.org/files/issues/ds-term_fdynamic_field_undefined_index_language-1391192-9.patch"
projects[environment][patch][] = "http://drupal.org/files/environment-remove-drush-force-error-1295412-1.patch"
projects[file_entity][patch][] = "http://drupal.org/files/issues/fix-private-file-permissions-2268335-1.patch"
projects[l10n_update][patch][] = "http://drupal.org/files/1421600-text_groups-7.patch"
projects[migrate_extras][patch][] = "http://drupal.org/files/migrate_extras_entity_api_entity_keys_name.patch"
projects[metatag][patch][] = "../patches/metatag_frontpage_fix_for_eandis.patch"
projects[nodequeue][patch][] = "https://www.drupal.org/files/node-mark-deprecated-1402634-7.patch"
projects[nodequeue][patch][] = "../patches/smartqueue-null-check.patch"
projects[panels][patch][] = "https://www.drupal.org/files/issues/panels-new-pane-alter-1985980-5.patch"
projects[panels][patch][] = "../patches/panels/patch_panels_undefined_index__settings.patch"
projects[panels][patch][] = "../patches/panels/panels-mini-undefined-bid.patch"
projects[panels_breadcrumbs][patch][] = "../patches/panels_breadcrumbs_unknown_index_panels_breadcrumbs_state.patch"
projects[shield][patch][] = "../patches/shield_second_user.patch"
projects[variable_realm][patch][] = "../patches/variable_realm_add_alter_hook.patch"
projects[views][patch][] = "http://drupal.org/files/issues/fix-views-missing-dom-id-1809958-7.patch"
