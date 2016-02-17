default['rundeck']['version'] = '2.6.2-1.13.GA'

default['rundeck']['base_dir'] = '/var/lib/rundeck'
default['rundeck']['conf_dir'] = '/etc/rundeck'

default['rundeck']['user'] = 'rundeck'
default['rundeck']['group'] = 'rundeck'
default['rundeck']['admin_user'] = 'admin'
default['rundeck']['admin_password'] = 'supersecretsauce'

default['rundeck']['server']['name'] = 'localhost'
default['rundeck']['server']['hostname'] = 'localhost'
default['rundeck']['server']['port'] = 4440
default['rundeck']['server']['url'] = "http://#{node['rundeck']['server']['hostname']}:#{node['rundeck']['server']['port']}"

default['rundeck']['ssh']['key_path'] = '/var/lib/rundeck/.ssh/id_rsa'
default['rundeck']['ssh']['user'] = 'rundeck'
default['rundeck']['ssh']['timeout'] = 5000 # it's in milliseconds
