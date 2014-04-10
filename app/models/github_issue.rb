class GithubIssue < ActiveRecord::Base

  attr_accessor :assigned_github_login, :github_login, :merged_github_login, :pull_request, :statuses, :token

  belongs_to :assigned_github_user, :class_name => 'GithubUser'
  belongs_to :merged_github_user,   :class_name => 'GithubUser'
  belongs_to :github_user

  belongs_to :lighthouse_ticket
  
  has_many :github_issue_statuses

  def file_changes
    self.file_additions + self.file_deletions
  end

  def needs_update?(issue)
    issue_updated_at != Time.parse(issue[:updated_at])
  end
end
