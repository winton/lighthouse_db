class GithubUser < ActiveRecord::Base

  def formatted_name
    u = (self.name || self.login).split(/\s+/)
    if u[1]
      u[0] + " " + u[1][0..0]
    else
      u[0]
    end
  end

  class <<self
    def group_by_team
      all_logins = []

      teams = GithubUserTeams.teams.collect do |team, logins|
        all_logins += logins
        [ team, GithubUser.where(login: logins) ]
      end

      teams << [ "Other", GithubUser.where.not(login: all_logins) ]
      teams
    end

    def token_user
      where("token IS NOT NULL").first
    end

    def update_teams!
      GithubUserTeams.teams.each do |team, logins|
        where(login: logins).update_all(team: team)
      end
    end
  end
end
