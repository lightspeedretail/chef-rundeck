require 'serverspec'
require_relative 'testing'
include Testing

set :backend, :exec

wait_for_rundeck_to_be_up

context 'Rundeck binded on 127.0.0.1' do
  describe command("netstat -nl | grep '127.0.0.1:4440'") do
    its(:exit_status) { should eq 0 }
  end
end
