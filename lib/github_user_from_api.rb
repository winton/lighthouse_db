class GithubUserFromApi < Struct.new(:user, :api)

  def update
    unless user.name
      gh = api.user(user)
      user.name = gh[:name]
    end

    user.save
  end
end