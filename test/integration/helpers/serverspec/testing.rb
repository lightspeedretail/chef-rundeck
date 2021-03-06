require 'json'
require 'net/http'

module Testing
  def get(endpoint, token)
    uri = URI("http://localhost:4440#{endpoint}?authtoken=#{token}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header('Accept' => 'application/json')
    res = http.request(request)
    raise 'API authentication problem' if res.code == '403'
    res.body
  end

  def job?(project, job, token)
    jobs = JSON.parse(get("/api/15/project/#{project}/jobs", token))
    jobs.select { |p| p['name'] == job }.empty? ? false : true
  end

  def project?(project, token)
    projects = JSON.parse(get('/api/15/projects', token))
    projects.select { |p| p['name'] == project }.empty? ? false : true
  end

  def token
    File.read('/etc/rundeck/tokens.properties').match(/^chef:(.*)/).to_s.split(':').last[1..-1]
  end

  def service_listening?
    uri = URI('http://localhost:4440/api')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(request)
    true if res.code == '200'
  rescue Errno::ECONNREFUSED
    false
  end

  def wait_for_rundeck_to_be_up
    puts ''
    puts 'Waiting for Rundeck to be up'
    sleep(1) until service_listening?
  end
end
