fsroot = node['jenkins_swarm']['parameters']['fsroot'].to_s
service_user = node['jenkins_swarm']['client']['service_user'].to_s

directory "#{fsroot}/.ssh" do
  mode 0700
  owner service_user
  group service_user
end

cookbook_file "#{fsroot}/.ssh/config" do
  source 'ssh_config'
  owner service_user
  group service_user
  mode 00644
end

# Creates a file that is only readable by root to store the password to login to Jenkins
template "#{fsroot}/.secret" do
  source 'secret.erb'
  mode 0000
  user 'root'
  group 'root'
  variables(secret: ENV['SWARM_PW'])
end

template '/etc/init.d/swarm' do
  source 'swarm_service.sh.erb'
  mode 0755
  variables(java_cmd: node['jenkins_swarm']['client']['java_cmd'])
  notifies :run, 'bash[reload_daemons]', :immediate
end

bash 'reload_daemons' do
  action :nothing
  code <<-EOH
    systemctl daemon-reload
  EOH
  notifies :restart, 'service[swarm]', :immediate
end

service 'swarm' do
  init_command '/etc/init.d/swarm'
  action [:enable, :start]
end
