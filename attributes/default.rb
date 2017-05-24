default['rundeck']['version'] = '2.8.2-1.31.GA'

default['rundeck']['base_dir'] = '/var/lib/rundeck'
default['rundeck']['conf_dir'] = '/etc/rundeck'
default['rundeck']['jobs_dir'] = "#{node['rundeck']['conf_dir']}/jobs"
default['rundeck']['logs_dir'] = '/var/log/rundeck'

default['rundeck']['user'] = 'rundeck'
default['rundeck']['group'] = 'rundeck'
default['rundeck']['admin_user'] = 'admin'
default['rundeck']['admin_password'] = 'supersecretsauce'

default['rundeck']['server']['name'] = 'localhost'
default['rundeck']['server']['hostname'] = 'localhost'
default['rundeck']['server']['host'] = '0.0.0.0'
default['rundeck']['server']['port'] = 4440
default['rundeck']['server']['url'] = "http://#{node['rundeck']['server']['hostname']}:#{node['rundeck']['server']['port']}"

default['rundeck']['server']['jvm']['xmx'] = '1024m'
default['rundeck']['server']['jvm']['xms'] = '1024m'

default['rundeck']['server']['ssl']['enabled'] = false
default['rundeck']['server']['ssl']['port'] = 4443

default['rundeck']['ssh']['key_path'] = '/var/lib/rundeck/.ssh/id_rsa'
default['rundeck']['ssh']['user'] = 'rundeck'
default['rundeck']['ssh']['timeout'] = 5000 # it's in milliseconds

default['rundeck']['custom_properties']['framework'] = {}
