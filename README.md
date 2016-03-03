This cookbook exposes resources to manage [Rundeck](http://rundeck.org/). The project and job resources use the API to avoid having to restart Rundeck all the time.

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

### Plugins

~~~ text
rundeck_plugin 'hipchat' do
  url 'https://search.maven.org/remotecontent?filepath=com/hbakkum/rundeck/plugins/rundeck-hipchat-plugin/1.5.0/rundeck-hipchat-plugin-1.5.0.jar'
  checksum '2017d6930e170752051f41e9936f3a285f3d340a6c0ff10931c456c4527f9ef4'
end
~~~

**NOTE: Be aware that you need to pass a SHA256 checksum as that's what remote_file expects.**

### API token

~~~ text
rundeck_api_key 'jdoe'
~~~

### ACLs

I didn't write a resource for that. I think it's simpler to just dump a file under `/etc/rundeck` if you need ACLs. That said, if someone has a good PR, I'd accept it.

## Contributing

+ Fork this repository
+ Make your changes in a feature branch
+ Commit your changes in small batches in case we need to cherry pick
+ Write tests for your changes
+ Make sure all tests pass
+ Open a pull request

## License and Authors

Author:: Jean-Francois Theroux (<me@failshell.io>)
