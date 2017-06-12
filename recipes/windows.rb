# Create OpenJDK file.
cookbook_file 'C:/Windows/Temp/java-1.8.0-openjdk-1.8.0.131-1.b11.redhat.windows.x86_64.msi' do
  source 'java-1.8.0-openjdk-1.8.0.131-1.b11.redhat.windows.x86_64.msi'
  action :create
  guard_interpreter :powershell_script
  only_if "(gwmi win32_Product | Where {$_.Name -match 'OpenJDK 1.8.0_131-1-redhat' -and $_.Version -eq '1.8.1311.11}' }) -eq $null"
end

# Install OpenJDK
windows_package 'Open JDK 8' do
  source 'C:/Windows/Temp/java-1.8.0-openjdk-1.8.0.131-1.b11.redhat.windows.x86_64.msi'
  action :install
  installer_type :msi
  guard_interpreter :powershell_script
  only_if "(gwmi win32_Product | Where {$_.Name -match 'OpenJDK 1.8.0_131-1-redhat' -and $_.Version -eq '1.8.1311.11}' }) -eq $null"
end

# Download WinSW for .NET4
remote_file "#{node['jenkins_swarm']['parameters']['fsroot']}\\jenkins_swarm.exe" do
  source 'https://github.com/kohsuke/winsw/releases/download/winsw-v2.1.0/WinSW.NET4.exe'
end

# Create config for swarm service for use with WinSW
template "#{node['jenkins_swarm']['parameters']['fsroot']}\\jenkins_swarm.xml" do
  source 'jenkins-swarm-windows.xml.erb'
  owner node['jenkins_swarm']['client']['service_user'].to_s
  mode 0600
  variables(
    user: node['jenkins_swarm']['client']['service_user'],
    pass: ENV['SWARM_PW'],
    domain: node['jenkins_swarm']['client']['service_domain'],
    swarm_version: node['jenkins_swarm']['client']['version'],
    swarm_command_line: node['jenkins_swarm']['client']['java_cmd']
  )
  notifies :run, 'powershell_script[remove_swarm_service]', :immediate
end

powershell_script 'remove_swarm_service' do
  cwd node['jenkins_swarm']['parameters']['fsroot'].to_s
  code <<-EOH
  .\\jenkins_swarm.exe stop
  .\\jenkins_swarm.exe uninstall
  EOH
  action :nothing
end

powershell_script 'install_swarm_service' do
  cwd node['jenkins_swarm']['parameters']['fsroot'].to_s
  code <<-EOH
  .\\jenkins_swarm.exe install
  EOH
  guard_interpreter :powershell_script
  not_if 'Get-Service -Name jenkins_swarm'
end

windows_service 'jenkins_swarm' do
  action [:enable, :start]
end
