class UpdateGithubUsers < Struct.new(:obj, :api, :org)

  def update
    assign_user(obj, :assigned_github_user=, obj.assigned_github_login)
    assign_user(obj, :github_user=,          obj.github_login)
    assign_user(obj, :merged_github_user=,   obj.merged_github_login)

    obj.github_issue_statuses.each do |status|
      assign_user(status, :github_user=, status.github_login)
    end
  end

  def assign_user(record, to, from)
    if record.respond_to?(to)
      record.send(to, create_user(from))
    end
  end

  def create_user(login)
    return unless login

    attributes = {
      login: login,
      org:   org
    }

    user = GithubUser.where(attributes).first_or_initialize
    GithubUserFromApi.new(user, api).update

    user
  end
end