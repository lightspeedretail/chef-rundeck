require_relative '../libraries/api'
include RundeckAPI

resource_name :rundeck_job

property :definition, String, required: true
property :job, String, name_property: true
property :project, String, required: true
property :token_file, String, default: '/etc/rundeck/tokens.properties'

def whyrun_supported?
  true
end

action :manage do
  token = token('chef', new_resource.token_file)

  return if job?(new_resource.project, new_resource.job, token)

  converge_by "create job '#{new_resource.job}' in '#{new_resource.project}'" do
    post("/api/15/project/#{new_resource.project}/jobs/import", token, new_resource.definition, 'yaml')
  end
end

action :remove do
  token = token('chef', new_resource.token_file)
  return unless job?(new_resource.project, new_resource.job, token)

  converge_by "deleting job '#{new_resource.job}'" do
    id = job_id(new_resource.project, new_resource.job, token)
    delete("/api/15/job/#{id}", token)
  end
end
