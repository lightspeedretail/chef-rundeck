require 'serverspec'
require_relative 'testing'
include Testing

set :backend, :exec

wait_for_rundeck_to_be_up

context 'Add user' do
  # FIXME: can't seem to get that to work the file resource
  describe command("egrep -e '^admin: MD5:[a-z0-9]{32},admin,user' /etc/rundeck/realm.properties") do
    its(:exit_status) { should eq 0 }
  end
end

context 'Remove user' do
  describe file('/etc/rundeck/realm.properties') do
    it { should_not contain /^jsmith/ }
  end
end

context 'Add API key' do
  describe file('/etc/rundeck/tokens.properties') do
    it { should contain /^jdoe/ }
  end
end

context 'Remove API key' do
  describe file('/etc/rundeck/tokens.properties') do
    it { should_not contain /^jsmith/ }
  end
end

context 'Create a project' do
  describe file('/var/lib/rundeck/projects/TestProject') do
    it { should be_directory }
  end

  # test a custom property
  describe file('/var/lib/rundeck/projects/TestProject/etc/project.properties') do
    it { should contain /project.ssh-keypath=\/tmp\/.ssh\/id_rsa/ }
  end
end

context 'Delete a project' do
  describe "rundeck project 'TestProject2'" do
    it 'should_not exist' do
      project = project?('TestProject2', token)
      expect(project).to be false
    end
  end
end

context 'Create a job' do
  describe "rundeck job 'test_job'" do
    it 'should exist' do
      job = job?('TestProject', 'test_job', token)
      expect(job).to be true
    end
  end
end

context 'Delete a job' do
  describe "rundeck job 'test_job2'" do
    it 'should not exist' do
      job = job?('TestProject', 'test_job2', token)
      expect(job).to be false
    end
  end
end

context 'Install plugin' do
  describe file('/var/lib/rundeck/libext/rundeck-hipchat-plugin-1.5.0.jar') do
    it { should be_file }
    it { should be_mode 400 }
    it { should be_owned_by 'rundeck' }
    it { should be_grouped_into 'rundeck' }
  end
end
