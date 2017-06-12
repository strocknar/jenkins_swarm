case node['platform_family']
when 'rhel'
  # include_recipe 'openjdk::default'
  yum_package node['openjdk']['package_name'] do
    action :install
  end
end
