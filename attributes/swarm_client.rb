#
# Cookbook:: jenkins_swarm
# Attributes:: client
#
# Authore: Robert Van Kleeck <rvankleeck@salesforce.com>
#

default['jenkins_swarm']['client'].tap do |client|
  #
  # Version of the swarm client to get
  #
  client['version'] = '3.3'
  #
  # Swarm client repo base URL
  #
  client['url'] = 'https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client'
  #
  # Actual location of the swarm client .JAR file. Built from the URL and Version
  #
  jar_name = "swarm-client-#{node['jenkins_swarm']['client']['version']}.jar"
  client['source'] = "#{node['jenkins_swarm']['client']['url']}/#{node['jenkins_swarm']['client']['version']}/#{jar_name}"
  #
  # Domain for the user that will run the service. Really only used for windows.
  #
  client['service_domain'] = '.'
  #
  # User that will run the swarm client .JAR file on the node
  #
  client['service_user'] = 'jenkins'
  #
  # Password for the user running the .JAR file
  #
  client['service_password'] = nil
  #
  # Where to store the downloaded file.
  #
  client['file_location'] = "#{node['jenkins_swarm']['parameters']['fsroot']}/#{jar_name}"
  #
  # Any extra configuration to add to Java when running the command
  #
  client['jvm_options'] = nil
  #
  # Whether or not to use SSH keys for the service user
  #
  client['service_user_ssh_keys'] = true
  #
  # Build the java command from Attributes
  # java -jar $swarm_file -disableSslVerification -deleteExistingClients -fsroot $jenkins_home -executors $executors -labels $labels -name $hostname -master $jenkins_master -username $username -passwordEnvVariable SWARM_PW &
  command = []
  command << %(java) if node['os'] != 'windows'
  command << client['jvm_options'].to_s unless client['jvm_options'].nil?
  command << %(-jar #{node['jenkins_swarm']['client']['file_location']})
  command << %(-disableSslVerification) if node['jenkins_swarm']['parameters']['no_ssl']
  command << %(-deleteExistingClients) if node['jenkins_swarm']['parameters']['delete_existing']
  command << %(-disableClientsUniqueId) unless node['jenkins_swarm']['parameters']['unique']
  command << %(-fsroot #{node['jenkins_swarm']['parameters']['fsroot']})
  command << %(-executors #{node['jenkins_swarm']['parameters']['executors']})
  command << %(-labels) if node['jenkins_swarm']['parameters']['labels'].any?
  node['jenkins_swarm']['parameters']['labels'].each do |label|
    command << label.to_s
  end
  command << %(-name #{node['jenkins_swarm']['parameters']['name']})
  command << %(-master #{node['jenkins_swarm']['parameters']['master']}) unless node['jenkins_swarm']['parameters']['master'].nil?
  command << %(-username #{node['jenkins_swarm']['parameters']['username']}) unless node['jenkins_swarm']['parameters']['username'].nil?
  command << %(-passwordEnvVariable SWARM_PW)
  client['java_cmd'] = command.join(' ')
end
