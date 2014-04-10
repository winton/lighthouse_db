class UpdateGithubStatuses < Struct.new(:record)

  def update
    record.github_issue_statuses.delete_all
    record.statuses.each do |status|
      record.github_issue_statuses << IssueStatusFromApi.new(status).update
    end
  end
end