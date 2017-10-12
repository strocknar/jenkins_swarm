#
# Cookbook:: jenkins_swarm
# Attributes:: parameters
#
# Authore: Robert Van Kleeck <rvankleeck@salesforce.com>
#

default['jenkins_swarm']['parameters'].tap do |parameters|
  #
  # The number of executors this slave should have
  #
  parameters['executors'] = 2
  #
  # Directory where Jenkins places files
  #
  parameters['fsroot'] = if node['os'] == 'windows'
                           'C:\\jenkins'
                         else
                           '/opt/jenkins'
                         end
  #
  # Any labels to apply to the slave
  #
  parameters['labels'] = []
  #
  # The mode controlling how Jenkins allocates jobs to slaves.
  # Can be either 'normal' (utilize this slave as much as possible) or
  # 'exclusive' (leave this machine for tied jobs only). Default is normal.
  #
  parameters['mode'] = 'normal'
  #
  # Complete target Jenkins URL (e.g. https://server:8080/jenkins/).
  # If this is not specified, autodiscovery will be attempted (but often fails)
  #
  parameters['master'] = nil
  #
  # Name of the slave as it will appear in jenkins. Defaults to FQDN of node
  #
  parameters['name'] = node['fqdn']
  #
  # Whether or not to disable ssl verification
  #
  parameters['no_ssl'] = true
  #
  # Whether or not to delete any existing clients with the same name
  #
  parameters['delete_existing'] = true
  #
  # Whether or not to use a unique ID appended to the name
  #
  parameters['unique'] = false
  #
  # Username to use when logging into Jenkins. This user should only have
  # the "Agent" permissions in jenkins
  # (Jenkins -> Manage Jenkins -> Manage and Assign Roles)
  # (https://<jenkins_server>/role-strategy/)
  #
  parameters['username'] = 'jenkins-svc'
  #
  # Password to use when logging into Jenkins. If this is not set, it will
  # look for an encrypted data bag called jenkins with an id of 'keys' and
  # an entry corresponding to the username.
  #
  parameters['password'] = nil
end
