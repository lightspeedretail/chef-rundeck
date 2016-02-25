require 'serverspec'
require_relative 'testing'
include Testing

set :backend, :exec

wait_for_rundeck_to_be_up

context 'Java' do
  describe package('java-1.7.0-openjdk') do
    it { should be_installed }
  end
end

context 'Installation' do
  describe file('/etc/yum.repos.d/rundeck.repo') do
    it { should exist }
  end

  %w(rundeck rundeck-config).each do |p|
    describe package(p) do
      it { should be_installed.with_version('2.6.2-1.13.GA') }
    end
  end

  describe service('rundeckd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe user('rundeck') do
    it { should exist }
    it { should belong_to_group 'rundeck' }
  end

  describe file('/etc/rundeck') do
    it { should be_directory }
    it { should be_mode 750 }
    it { should be_owned_by 'rundeck' }
    it { should be_grouped_into 'rundeck' }
  end

  describe file('/var/lib/rundeck') do
    it { should be_directory }
    it { should be_mode 750 }
    it { should be_owned_by 'rundeck' }
    it { should be_grouped_into 'rundeck' }
  end

  describe file('/var/lib/rundeck/projects') do
    it { should be_directory }
    it { should be_mode 750 }
    it { should be_owned_by 'rundeck' }
    it { should be_grouped_into 'rundeck' }
  end

  describe file('/etc/rundeck/jobs') do
    it { should be_directory }
    it { should be_mode 750 }
    it { should be_owned_by 'rundeck' }
    it { should be_grouped_into 'rundeck' }
  end

  describe file('/var/rundeck') do
    it { should_not exist }
  end
end

context 'Service' do
  describe port(4440) do
    it { should be_listening.on('::').with('tcp6') }
  end

  describe command('curl -s http://localhost:4440/user/login > /dev/null') do
    its(:exit_status) { should eq 0 }
  end
end

context 'Configuration' do
  %w(realm framework tokens rundeck-config).each do |e|
    describe file("/etc/rundeck/#{e}.properties") do
      it { should be_file }
      it { should be_mode 400 }
      it { should be_owned_by 'rundeck' }
      it { should be_grouped_into 'rundeck' }
    end
  end
end

context 'No admin user' do
  describe file('/etc/rundeck/realm.properties') do
    it { should_not contain /^admin/ }
  end
end

context 'Chef API key' do
  describe file('/etc/rundeck/tokens.properties') do
    it { should contain /^chef/ }
  end
end
