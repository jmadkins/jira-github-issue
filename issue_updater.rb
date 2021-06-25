require 'csv'
require 'dotenv/load'
require 'pry'

require_relative 'issue_importer/github_gateway'

gateway = GithubGateway.new(ENV['GITHUB_URL'], ENV['GITHUB_USER'], ENV['GITHUB_PASS'])
gateway.issue_search('type:issue in:title HUB repo:mythcoders/hubble').each do |issue|
  puts "#{issue.number} ..."
  jira_key = issue.title[/HUB-\d+/]
  next if jira_key.nil?

  puts "#{issue.number} ... found #{jira_key}"
  new_title = issue.title.gsub(/\s-\sHUB-\d+/, '')
  updated_params = {
    title: new_title,
    body: "#{issue.body}\n\nPreviously was #{jira_key}."
  }

  gateway.update_issue(issue.number, updated_params)
  sleep 2
end
