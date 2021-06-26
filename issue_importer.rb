require 'csv'
require 'dotenv/load'
require 'pry'

require_relative 'issue_importer/github_gateway'
require_relative 'issue_importer/jira_issue'

file_path = ARGV[0]

issues = CSV.foreach(file_path, headers: true).map do |line|
  JiraIssue.new(line)
end

params = {
  url: ENV['GITHUB_URL'],
  username: ENV['GITHUB_USER'],
  password: ENV['GITHUB_PASS'],
  repo: 'mythcoders/ecclesia'
}

gateway = GithubGateway.new(params)
issues.each do |issue|
  puts issue.title
  gateway.create_issue issue.to_params
  sleep 2
end
