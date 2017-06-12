#
# Cookbook:: jenkins_swarm
# Recipe:: swarm_client
#
include_recipe 'jenkins_swarm::prereqs'

if node['jenkins_swarm']['parameters']['password'].nil?
  Chef::Log.warn('Password not set. Getting encrypted data bag contents')
  jenkins_keys = Chef::EncryptedDataBagItem.load('jenkins', 'keys')
  # Chef::Log.warn("-=# SWARM_PW: #{jenkins_keys[node['jenkins_swarm']['parameters']['username']]}")
  ENV['SWARM_PW'] = jenkins_keys[node['jenkins_swarm']['parameters']['username']]
else
  ENV['SWARM_PW'] = node['jenkins_swarm']['parameters']['password']
end

user node['jenkins_swarm']['client']['service_user'].to_s do
  action :create
  home node['jenkins_swarm']['parameters']['fsroot'].to_s
  unless node['jenkins_swarm']['client']['service_password'].nil?
    password node['jenkins_swarm']['client']['service_password'].to_s
  end
end

directory node['jenkins_swarm']['parameters']['fsroot'].to_s do
  owner node['jenkins_swarm']['client']['service_user'].to_s
  group node['jenkins_swarm']['client']['service_user'].to_s
  mode 0755
  action :create
end

remote_file node['jenkins_swarm']['client']['file_location'].to_s do
  source node['jenkins_swarm']['client']['source']
  mode 0644
  owner node['jenkins_swarm']['client']['service_user'].to_s
  group node['jenkins_swarm']['client']['service_user'].to_s
end

begin
  include_recipe "jenkins_swarm::#{node['os']}"
rescue Chef::Exceptions::RecipeNotFound
  raise Chef::Exceptions::RecipeNotFound, "The #{node['os']} operating system " \
    'is not supported by this cookbook.'
end
