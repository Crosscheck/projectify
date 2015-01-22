projectify
==========

A gem to set up a Drupal 7 project structure.

Usage
-----

Install the gem:

  gem install projectify

Run projectify to create a new project:

  gitify --namespace=crosscheck -a -p drupal --directory=. --gitlab_token=DLJxJRHoimUD7fj83pV1 --gitlab_domain=gitlab.crosscheck.be --project_name=Test_Project --domain=test-project.dev -r https://github.com/Crosscheck/VagrantDrupalDev


Place your search_api or apache_solr config files in etc/solr
