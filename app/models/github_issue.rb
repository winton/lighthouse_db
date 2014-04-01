class GithubIssue < ActiveRecord::Base

  attr_accessor :assigned_github_user, :github_user, :pull_request, :token

  belongs_to :assigned_github_user, :class_name => 'GithubUser'
  belongs_to :github_user
end
