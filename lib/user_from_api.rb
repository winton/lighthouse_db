class UserFromApi < Struct.new(:user, :token)

  def update
    unless user.job || user.name
      lh = Lighthouse.new(user, token).user
      user.job  = lh[:job]
      user.name = lh[:name]
    end

    user.save
  end
end