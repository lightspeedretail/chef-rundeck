require_relative '../libraries/api'
include RundeckAPI

resource_name :rundeck_api_key

property :token, String, required: true, name_property: true
property :token_file, String, default: '/etc/rundeck/tokens.properties'

def whyrun_supported?
  true
end

action :manage do
  return if token?(new_resource.name, new_resource.token_file)

  converge_by "creating API token '#{new_resource.name}'" do
    token = create_token
    ::File.open(new_resource.token_file, 'a').puts "#{new_resource.name}: #{token}\n"
  end
end

action :remove do
  return unless token?(new_resource.name, new_resource.token_file)

  converge_by "removing API token '#{new_resource.name}'" do
    config = ::File.read(new_resource.token_file).split("\n")
    config.reject! { |item| item =~ /^#{new_resource.name}:(.*)/ }
    ::File.write(new_resource.token_file, "#{config.join("\n")}\n")
  end
end
