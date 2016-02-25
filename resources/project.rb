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

  data = { 'name' => new_resource.name, 'config' => { 'description' => new_resource.description } }
  data['config'].merge!(new_resource.properties) if new_resource.properties

  return if project?(new_resource.project, token)

  converge_by "creating project '#{new_resource.project}'" do
    post('/api/15/projects', token, data.to_json)
  end
end

action :remove do
  wait_for_rundeck_to_be_up

  token = token('chef', new_resource.token_file)

  return unless project?(new_resource.project, token)

  converge_by "deleting project '#{new_resource.project}'" do
    puts delete("/api/15/project/#{new_resource.project}", token)
  end
end
