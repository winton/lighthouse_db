class IssueStatusFromApi < Struct.new(:status)

  def update
    record     = GithubIssueStatus.where(number: status[:id]).first_or_initialize
    attributes = to_attributes
    record.assign_attributes(attributes)
    record
  end

  def to_attributes
    {
      description:  status[:description],
      number:       status[:id],
      state:        status[:state],
      target_url:   status[:target_url],
      url:          status[:url],

      github_login: (status[:creator][:login] rescue nil),

      status_created_at: status[:created_at],
      status_updated_at: status[:updated_at]
    }
  end
end