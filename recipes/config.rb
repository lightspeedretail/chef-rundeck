#
# Cookbook Name:: rundeck
# Recipe:: config
#
# Copyright (C) 2016 Jean-Francois Theroux
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

%w[framework realm tokens rundeck-config].each do |t|
  template "#{node['rundeck']['conf_dir']}/#{t}.properties" do
    owner node['rundeck']['user']
    group node['rundeck']['group']
    mode 0o400
    sensitive true
    notifies :restart, 'service[rundeckd]'
    not_if "grep 'Managed by Chef' #{node['rundeck']['conf_dir']}/#{t}.properties" unless t =~ /(framework|rundeck-config)/
  end
end

# This file controls the authentication module at the login page
# If Rundeck refuses all users and passwords, get rid of this
template File.join(node['rundeck']['conf_dir'], 'jaas-loginmodule.conf') do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  mode 0o400
  notifies :restart, 'service[rundeckd]'
end

template File.join(node['rundeck']['conf_dir'], 'profile') do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  mode 0o400
  sensitive true
  notifies :restart, 'service[rundeckd]'
end

cookbook_file '/etc/rundeck/apitoken.aclpolicy' do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  mode 0o400
  sensitive true
end

# Let Chef manage Rundeck.
rundeck_api_key 'chef'
