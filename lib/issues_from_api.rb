class IssuesFromApi < Struct.new(:user)

  include RecordsFromApi

  def create(api, record, api_record)
    IssueFromApi.new(api, api_record, record, user).update
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