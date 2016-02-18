require 'digest/md5'

module Helpers
  def compare_user?(new_auth_line, realm)
    user = new_auth_line.split(':').first
    current_auth_line = File.read(realm).match(/^#{user}(.*)/).to_s
    current_auth_line == new_auth_line ? true : false
  end

  def user?(user, realm)
    File.read(realm).match(/^#{user}:/) ? true : false
  end

  def md5(password)
    Digest::MD5.hexdigest(password)
  end
end
