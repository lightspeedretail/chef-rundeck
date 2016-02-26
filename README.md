This cookbook exposes resources to manage [Rundeck](http://rundeck.org/).

## Usage

+ Write a wrapper cookbook that includes this cookbook
+ In the wrapper cookbook, use the resources as needed

## Resources

### User

~~~ text
rundeck_user 'admin' do
  password node['rundeck']['admin_password']
  roles %w(admin user)
end
~~~

**NOTE: password must be the unencrypted password string, as it will automatically be converted to MD5**

### Project

~~~ text
rundeck_project 'TestProject' do
  description 'Test Project'
  properties 'project.ssh-keypath' => '/tmp/.ssh/id_rsa'
end
~~~

**NOTE: properties must be a Hash**

### Jobs

~~~ text
job_file = "#{node['rundeck']['jobs_dir']}/test_job.yaml"
cookbook_file job_file

rundeck_job 'test_job' do
  project 'TestProject'
  definition lazy { File.read(job_file) }
end
~~~

**NOTE: the job file must be YAML**

### API token

~~~ text
rundeck_api_key 'jdoe'
~~~

## Contributing

+ Fork this repository
+ Make your changes in a feature branch
+ Commit your changes in small batches in case we need to cherry pick
+ Write tests for your changes
+ Make sure all tests pass
+ Open a pull request

## License and Authors

Author:: Jean-Francois Theroux (<me@failshell.io>)
