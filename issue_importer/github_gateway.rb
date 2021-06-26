require 'faraday'
require 'json'
require 'hashie'
require 'mime-types'

class GithubGateway
  def initialize(params)
    @url = params[:url]
    @username = params[:username]
    @password = params[:password]
    @repo = params[:repo]
  end

  def create_issue(issue)
    conn = api_connection("#{@url}/repos/#{@repo}/issues")
    response = conn.post { |req| req.body = JSON.dump(issue) }

    if response.success?
      puts '✅ Issue created'
      return true
    end

    puts "❌ Issue not create - (#{response.status}) #{response.body}"
  end

  def get_issues
    response = api_connection("#{@url}/repos/#{@repo}/issues?per_page=100").get
    return JSON.parse(response.body).map { |p| Hashie::Mash.new(p) } if response.success?

    puts "❌ Issues not fetched - (#{response.status}) #{response.body}"
  end

  def issue_search(query)
    response = api_connection("#{@url}/search/issues?q=#{query}&per_page=100").get
    return JSON.parse(response.body)['items'].map { |p| Hashie::Mash.new(p) } if response.success?

    puts "❌ Issues not fetched - (#{response.status}) #{response.body}"
  end

  def update_issue(issue_number, issue)
    conn = api_connection("#{@url}/repos/#{@repo}/issues/#{issue_number}")
    response = conn.patch { |req| req.body = JSON.dump(issue) }

    if response.success?
      puts '✅ Issue updated'
      return true
    end

    puts "❌ Issue not updated - (#{response.status}) #{response.body}"
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
