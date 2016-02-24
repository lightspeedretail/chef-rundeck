require 'json'
require 'net/http'
require 'securerandom'

module RundeckAPI
  def delete(endpoint, token)
    uri = URI("#{node['rundeck']['server']['url']}#{endpoint}?authtoken=#{token}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri.request_uri)
    http.request(request)
  end

  def get(endpoint, token)
    uri = URI("#{node['rundeck']['server']['url']}#{endpoint}?authtoken=#{token}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header('Accept' => 'application/json')
    res = http.request(request)
    fail 'API authentication problem' if res.code == '403'
    res.body
  end

  def job?(project, job, token)
    jobs = JSON.parse(get("/api/15/project/#{project}/jobs", token))
    jobs.select { |p| p['name'] == job }.empty? ? false : true
  end

  def job_id(project, job, token)
    jobs = JSON.parse(get("/api/15/project/#{project}/jobs", token))
    jobs = jobs.select { |p| p['name'] == job }
    fail "More than one job named '#{job}'. Aborting." unless jobs.count == 1
    jobs.first['id']
  end

  def post(endpoint, token, data, format = 'json')
    uri = URI("#{node['rundeck']['server']['url']}#{endpoint}?authtoken=#{token}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.initialize_http_header('Content-Type' => "application/#{format}")
    request.body = data
    http.request(request)
  end

  def project?(project, token)
    projects = JSON.parse(get('/api/15/projects', token))
    projects.select { |p| p['name'] == project }.empty? ? false : true
  end

  def create_token
    SecureRandom.hex(32)
  end

  def token(user, token_file)
    File.read(token_file).match(/^#{user}:(.*)/).to_s.split(':').last[1..-1]
  end

  def token?(user, token_file)
    File.read(token_file).match(/^#{user}:/) ? true : false
  end
end
