require 'csv'
require 'dotenv/load'
require 'pry'

require_relative 'issue_importer/github_gateway'
require_relative 'issue_importer/jira_issue'

file_path = ARGV[0]

issues = CSV.foreach(file_path, headers: true).map do |line|
  JiraIssue.new(line)
end

gateway = GithubGateway.new(ENV['GITHUB_URL'], ENV['GITHUB_USER'], ENV['GITHUB_PASS'])
issues.each do |issue|
  puts issue.to_s
  gateway.create_issue issue.to_params
  sleep 3
end
