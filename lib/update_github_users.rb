class UpdateGithubUsers < Struct.new(:obj, :api, :org)

  def update
    if obj.respond_to?(:assigned_github_user=)
      obj.assigned_github_user = create_user(obj.assigned_github_login)
    end

    if obj.respond_to?(:github_user=)
      obj.github_user = create_user(obj.github_login)
    end

    if obj.respond_to?(:merged_github_user=)
      obj.merged_github_user = create_user(obj.merged_github_login)
    end

    obj.github_issue_statuses.each do |status|
      if status.respond_to?(:github_user=)
        obj.github_user = create_user(status.github_login)
      end
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