class IssueFromApi < Struct.new(:record, :api_record)

  include RecordFromApi

  def klass
    GithubIssue
  end

  def to_attributes(i)
    repo_regex = /github.com\/repos\/([^\/]+\/[^\/]+)/
    repo       = i[:url].match(repo_regex)[1] rescue nil
    assigned   = i[:assignee][:login]         rescue nil
    user       = i[:user][:login]             rescue nil
    {
      assigned_github_user: assigned,
      repo:                 repo,
      github_user:          user,
      number:               i[:number],
      pull_request:         i[:pull_request],
      state:                i[:state],
      title:                i[:title],
      url:                  i[:url],
      body:                 i[:body]
    }
  end
end