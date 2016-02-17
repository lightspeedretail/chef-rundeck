require 'serverspec'

set :backend, :exec

shared_examples 'Java' do
  describe package('java-1.8.0-openjdk') do
    it { should be_installed }
  end
end
