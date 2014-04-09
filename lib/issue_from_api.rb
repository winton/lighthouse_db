class IssueFromApi < Struct.new(:api, :api_record, :record, :user)

  include RecordFromApi

  def after_assign
    UpdateGithubUsers.new(record, api, user.org).update
    UpdatePullRequest.new(record, api).update
    UpdateIssueRelationships.new(record, api).update
    record.save
  end

  def klass
    GithubIssue
  end

  def to_attributes(i)
    repo_regex = /github.com\/repos\/([^\/]+\/[^\/]+)/
    repo       = i[:url].match(repo_regex)[1] rescue nil
    assigned   = i[:assignee][:login]         rescue nil
    user       = i[:user][:login]             rescue nil
    {
      assigned_github_login: assigned,
      repo:                  repo,
      github_login:          user,
      number:                i[:number],
      pull_request:          i[:pull_request],
      state:                 i[:state],
      title:                 i[:title],
      url:                   i[:html_url],
      body:                  (i[:body][0..40959] rescue nil),
      issue_created_at:      i[:created_at],
      issue_updated_at:      i[:updated_at],
      issue_closed_at:       i[:closed_at]
    }
  end
end