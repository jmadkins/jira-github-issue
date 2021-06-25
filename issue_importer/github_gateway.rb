require 'faraday'
require 'json'
require 'mime-types'

class GithubGateway
  def initialize(url, username, password)
    @url = url
    @username = username
    @password = password
  end

  def create_issue(issue)
    conn = api_connection("#{@url}/issues")
    response = conn.post { |req| req.body = JSON.dump(issue) }

    if response.success?
      puts '✅ Issue created'
      return true
    end

    puts "❌ Issue Not Created - (#{response.status}) #{response.body}"
  end

  private

  def api_connection(url, content_type = 'application/json')
    Faraday.new(url: url) do |faraday|
      faraday.basic_auth(@username, @password)
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-Type'] = content_type
      faraday.headers['Accept'] = 'application/vnd.github.v3+json'
    end
  end
end
