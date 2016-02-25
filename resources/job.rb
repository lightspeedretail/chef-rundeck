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
  wait_for_rundeck_to_be_up

  token = token('chef', new_resource.token_file)

  if job?(new_resource.project, new_resource.job, token)
    id = job_id(new_resource.project, new_resource.job, token)
    current_job = get("/api/15/job/#{id}", token, 'yaml').split("\n")
    current_job.reject! { |line| line =~ /(id:|uuid:)/ }

    return if current_job.join("\n") == new_resource.definition.chomp("\n")

    converge_by "#{action} job '#{new_resource.job}' in '#{new_resource.project}'" do
      parameters = { 'dupeOption' => 'update' }
      post("/api/15/project/#{new_resource.project}/jobs/import", token, new_resource.definition, 'yaml', parameters)
    end
  else
    converge_by "create job '#{new_resource.job}' in '#{new_resource.project}'" do
      post("/api/15/project/#{new_resource.project}/jobs/import", token, new_resource.definition, 'yaml')
    end
  end
end

action :remove do
  wait_for_rundeck_to_be_up

  token = token('chef', new_resource.token_file)
  return unless job?(new_resource.project, new_resource.job, token)

  converge_by "deleting job '#{new_resource.job}'" do
    id = job_id(new_resource.project, new_resource.job, token)
    delete("/api/15/job/#{id}", token)
  end
end
