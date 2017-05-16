require 'json'
require_relative '../libraries/api'
include RundeckAPI

resource_name :rundeck_project

property :description, String, required: true
property :project, String, required: true, name_property: true
property :properties, Hash
property :token_file, String, default: '/etc/rundeck/tokens.properties'

def whyrun_supported?
  true
end

action :manage do
  wait_for_rundeck_to_be_up

  token = token('chef', new_resource.token_file)

  data = { 'name' => new_resource.name, 'config' => {} }
  data['config'].merge!(new_resource.properties) if new_resource.properties

  file "#{node['rundeck']['base_dir']}/projects/#{new_resource.project}/readme.md" do
    owner node['rundeck']['user']
    group node['rundeck']['group']
    mode 0o400
    content "\n#{new_resource.description}\n"
  end

  file "#{node['rundeck']['base_dir']}/projects/#{new_resource.project}/motd.md" do
    owner node['rundeck']['user']
    group node['rundeck']['group']
    mode 0o400
  end

  if project?(new_resource.project, token)
    current_config = JSON.parse(get("/api/15/project/#{new_resource.project}/config", token))
    new_config = current_config.merge(new_resource.properties) if new_resource.properties

    return if current_config == new_config

    converge_by "updating project '#{new_resource.project}'" do
      put("/api/15/project/#{new_resource.project}/config", token, new_config.to_json)
    end
  else
    converge_by "creating project '#{new_resource.project}'" do
      post('/api/15/projects', token, data.to_json)
    end
  end
end

action :remove do
  wait_for_rundeck_to_be_up

  token = token('chef', new_resource.token_file)

  return unless project?(new_resource.project, token)

  converge_by "deleting project '#{new_resource.project}'" do
    delete("/api/15/project/#{new_resource.project}", token)
  end
end
