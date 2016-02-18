require 'spec_helper'

context 'Rundeck server' do
  it_behaves_like 'Java'
  it_behaves_like 'Installation'
  it_behaves_like 'Service'
  it_behaves_like 'Configuration'
end
