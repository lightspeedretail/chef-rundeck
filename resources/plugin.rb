resource_name :rundeck_plugin

property :checksum, String, required: true
property :plugin, String, name_property: true
property :url, String, required: true

def whyrun_supported?
  true
end

action :manage do
  file_name = new_resource.url.split('/').last
  converge_by "installing rundeck plugin '#{new_resource.plugin}'" do
    remote_file "#{node['rundeck']['base_dir']}/libext/#{file_name}" do
      owner node['rundeck']['user']
      group node['rundeck']['group']
      mode 0400
      source new_resource.url
      checksum new_resource.checksum
    end
  end
end

action :delete do
  converge_by "deleting rundeck plugin '#{new_resource.plugin}'" do
    file "#{node['rundeck']['base_dir']}/libext/#{file_name}" do
      action :delete
    end
  end
end
