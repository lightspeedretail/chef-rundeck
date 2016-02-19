require 'digest/md5'

module RundeckUser
  def compare_user?(new_auth_line, realm)
    user = new_auth_line.split(':').first
    current_auth_line = File.read(realm).match(/^#{user}(.*)/).to_s
    current_auth_line == new_auth_line ? true : false
  end

  def md5(string)
    Digest::MD5.hexdigest(string)
  end

  def token?(user, token)
    File.read(token).match(/^#{user}:/) ? true : false
  end

  def user?(user, realm)
    File.read(realm).match(/^#{user}:/) ? true : false
  end
end
