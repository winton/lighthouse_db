class GithubIssueStatus < ActiveRecord::Base

  attr_accessor :github_login

  belongs_to :github_issue
  belongs_to :github_user
end
