# # encoding: utf-8

# Inspec test for recipe sf_jenkins_swarm::swarm_client

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('jenkins') do
  it { should exist }
end

if os[:family] == 'windows'
  describe file('C:\\jenkins') do
    it { should be_directory }
  end
  describe file('C:\\jenkins\\swarm-client-3.3.jar') do
    it { should exist }
    it { should_not be_directory }
  end
  describe service('jenkins_swarm') do
    it { should be_enabled }
    it { should be_running }
  end
else
  describe file('/opt/jenkins') do
    it { should be_directory }
    it { should be_owned_by 'jenkins' }
    its('mode') { should cmp '00755' }
  end
  describe file('/opt/jenkins/swarm-client-3.3.jar') do
    it { should exist }
    it { should_not be_directory }
    it { should be_owned_by 'jenkins' }
    its('mode') { should cmp '00644' }
    its('group') { should eq 'jenkins' }
  end
  describe file('/opt/jenkins/.secret') do
    it { should exist }
    it { should_not be_directory }
    it { should be_owned_by 'root' }
    its('mode') { should cmp '00000' }
    its('group') { should eq 'root' }
    its('content') { should match(/keepitsecret_keepitsafe/) }
  end
  describe file('/opt/jenkins/.ssh') do
    it { should be_directory }
    it { should be_owned_by 'jenkins' }
    its('mode') { should cmp '00700' }
  end
  describe file('/opt/jenkins/.ssh/id_rsa') do
    it { should exist }
    it { should_not be_directory }
    it { should be_owned_by 'jenkins' }
    its('mode') { should cmp '00600' }
    its('group') { should eq 'jenkins' }
    its('content') { should match(/-----BEGIN RSA PRIVATE KEY-----/) }
  end
  describe file('/opt/jenkins/.ssh/id_rsa.pub') do
    it { should exist }
    it { should_not be_directory }
    it { should be_owned_by 'jenkins' }
    its('mode') { should cmp '00644' }
    its('group') { should eq 'jenkins' }
    its('content') { should match(/ssh-rsa XXXXXXXXXXXXXXXXXX/) }
  end
  # This doesn't work as it has to source the bashrc to find it
  # https://github.com/chef/inspec/issues/1784
  # describe os_env('PATH') do
  #   its('content') { should match %r{\.local/bin:} }
  # end
  describe file('/etc/systemd/system/swarm.service') do
    it { should exist }
    it { should_not be_directory }
    it { should be_owned_by 'root' }
    its('mode') { should cmp '00755' }
    its('group') { should eq 'root' }
    its('content') { should match(/test_label/) }
  end
end
