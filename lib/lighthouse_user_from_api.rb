class LighthouseUserFromApi < Struct.new(:user, :api)

  def update
    unless user.job || user.name
      lh = api.user(user)
      user.job  = lh[:job]
      user.name = lh[:name]
    end

    user.save
  end
end