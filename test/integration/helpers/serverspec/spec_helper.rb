require 'serverspec'

set :backend, :exec

shared_examples 'Java' do
  describe package('java-1.7.0-openjdk') do
    it { should be_installed }
  end
end

shared_examples 'Installation' do
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
end
