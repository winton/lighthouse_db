class GithubIssue < ActiveRecord::Base

  attr_accessor :assigned_github_login, :github_login, :pull_request, :token

  belongs_to :assigned_github_user, :class_name => 'GithubUser'
  belongs_to :github_user
  belongs_to :lighthouse_ticket

  def needs_update?(issue)
    issue_updated_at != Time.parse(issue[:updated_at])
  end
end
