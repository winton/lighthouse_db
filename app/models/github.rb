class Github < Api

  def initialize(*args)
    @user    = args.detect { |a| a.is_a?(GithubUser) }
    @api_url = "https://api.github.com"
    
    super()

    @http.headers['Authorization'] = "token #{@user.token}"
  end

  def pull_request(pull_request_path)
    response = @http.get(pull_request_path).body
    parse_response(response)
  end

  def pull_request_commits(pull_request_path)
    response = @http.get("#{pull_request_path}/commits").body
    parse_response(response)
  end

  def pull_request_files(pull_request_path)
    response = @http.get("#{pull_request_path}/files").body
    parse_response(response)
  end

  def pull_request_merged(pull_request_path)
    response = @http.get("#{pull_request_path}/merge").status
    response == 204
  end

  def recently_updated_issues(page=1, per_page=100)
    response = @http.get(
      "/orgs/#{@user.org}/issues",
      filter:   "all",
      page:     page,
      per_page: per_page,
      sort:     "updated",
      state:    "all"
    ).body

    parse_response(response)
  end

  def ref_statuses(url)
    response = @http.get(url).body
    parse_response(response)
  end

  def user(user=nil)
    user   ||= @user
    response = @http.get("/users/#{user.login}").body
    parse_response(response)
  end
end