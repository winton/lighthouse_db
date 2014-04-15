class GithubUser < ActiveRecord::Base

  class <<self
    def token_user
      where("token IS NOT NULL").first
    end
  end
end
