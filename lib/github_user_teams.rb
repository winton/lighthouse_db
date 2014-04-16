class GithubUserTeams
  class << self

    def teams
      load! unless @teams
      @teams
    end

    def load!
      @teams = YAML.load_file("#{Rails.root}/config/teams.yml")
    end
  end
end