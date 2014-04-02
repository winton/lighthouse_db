class Github < Api

  def initialize(*args)
    @user    = args.detect { |a| a.is_a?(GithubUser) }
    @api_url = "https://api.github.com"
    
    super()

    @http.headers['Authorization'] = "token #{@user.token}"
  end

  def recently_updated_issues(page=1, per_page=100)
    response = @http.get(
      "/orgs/#{@user.org}/issues",
      filter:   "all",
      page:     page,
      per_page: per_page,
      sort:     "updated"
    ).body

    parse_response(response)
  end

  def user(user=nil)
    user   ||= @user
    response = @http.get("/users/#{user.login}").body
    parse_response(response)
  end
end