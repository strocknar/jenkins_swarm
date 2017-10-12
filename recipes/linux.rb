fsroot = node['jenkins_swarm']['parameters']['fsroot'].to_s
service_user = node['jenkins_swarm']['client']['service_user'].to_s
jenkins_keys = data_bag_item('jenkins', 'keys')


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

if node['jenkins_swarm']['client']['service_user_ssh_keys']
  node.run_state['private_key'] = jenkins_keys[service_user]['private'].to_s
  node.run_state['public_key'] = jenkins_keys[service_user]['public'].to_s

  file "#{fsroot}/.ssh/id_rsa" do
    content node.run_state['private_key']
    mode 0600
    owner service_user
    group service_user
    sensitive true
  end

  file "#{fsroot}/.ssh/id_rsa.pub" do
    content node.run_state['public_key']
    mode 0644
    owner service_user
    group service_user
    sensitive true
  end
end


# Creates a file that is only readable by root to store the password to login to Jenkins
template "#{fsroot}/.secret" do
  source 'secret.erb'
  mode 0000
  user 'root'
  group 'root'
  variables(secret: ENV['SWARM_PW'])
  sensitive true
end

template '/etc/systemd/system/swarm.service' do
  source 'swarm.service.erb'
  mode 0755
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
  # init_command '/etc/init.d/swarm'
  # status_command '/etc/init.d/swarm status'
  action [:enable, :start]
end
