name 'jenkins_swarm'
maintainer 'Salesforce Infrastructure Automation'
maintainer_email 'rvankleeck@salesforce.com'
license 'all_rights'
description 'Installs/Configures jenkins swarm on a node'
long_description 'Installs/Configures jenkins swarm on a node'
version '1.1.6'
chef_version '>= 12.6' if respond_to?(:chef_version)
supports 'centos windows'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/strocknar/jenkins_swarm/issues'

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/strocknar/jenkins_swarm'
