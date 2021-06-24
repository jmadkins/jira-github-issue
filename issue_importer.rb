require 'dotenv/load'
# require 'issue_importer/github_gateway'
require_relative 'issue_importer/issue'
# Dotenv.require_keys('GITHUB_USER', 'GITHUB_PASS')

file_path = ARGV[0]
document = Nokogiri::XML IO.read(file_path)

issues = IO.foreach(file_path).map { |line| Issue.new(line) }
issues.each do |issue|
  puts issue.title
  # call the github api once each line has been converted into an issue
end
