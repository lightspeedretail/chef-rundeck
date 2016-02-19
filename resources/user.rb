require_relative '../libraries/user'
include RundeckUser

resource_name :rundeck_user

property :api_token, default: false
property :password, String, required: true
property :realm_file, String, default: '/etc/rundeck/realm.properties'
property :roles, Array, required: true
property :token_file, String, default: '/etc/rundeck/tokens.properties'
property :user, String, required: true, name_property: true

def whyrun_supported?
  true
end

action :manage do
  user = new_resource.user
  hash = md5(new_resource.password)
  roles = new_resource.roles.join(',')
  auth_line = "#{user}: MD5:#{hash},#{roles}"

  if new_resource.api_token
    return if token?(new_resource.user, new_resource.token_file)

    converge_by "creating API token for '#{new_resource.user}'" do
      token = md5(md5(new_resource.password))
      ::File.open(new_resource.token_file, 'a').puts "#{new_resource.user}: #{token}\n"
    end
  end

  if user?(new_resource.user, new_resource.realm_file)
    return if compare_user?(auth_line, new_resource.realm_file)

    converge_by "updating user '#{new_resource.user}'" do
      current_config = ::File.read(new_resource.realm_file)
      current_user = current_config.match(/^#{user}(.*)/).to_s
      new_config = current_config.gsub!(/#{current_user}/, auth_line)
      ::File.write(new_resource.realm_file, new_config)
    end
  else
    converge_by "creating user '#{new_resource.user}'" do
      ::File.open(new_resource.realm_file, 'a').puts "#{auth_line}\n"
    end
  end
end

action :remove do
  return unless user?(new_resource.user, new_resource.realm_file)

  converge_by "removing user '#{new_resource.user}'" do
    config = ::File.read(new_resource.realm_file).split("\n")
    config.reject! { |item| item =~ /^#{user}:(.*)/ }
    ::File.write(new_resource.realm_file, "#{config.join("\n")}\n")
  end
end
