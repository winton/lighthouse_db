class IssuesFromApi < Struct.new(:user)

  include RecordsFromApi

  def create(api, record, api_record)
    record       = IssueFromApi.new(record, api_record).update
    record.token = user.token

    UpdateGithubUsers.new(record, api, user.org).update
    
    record.save
  end

  def klass
    GithubIssue
  end

  def recently_updated(page, limit)
    [
      api = Github.new(user),
      api.recently_updated_issues(page, limit)
    ]
  end
end