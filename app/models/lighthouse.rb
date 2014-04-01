class Lighthouse < Api

  attr_reader :token

  def initialize(*args)
    @user  = args.detect { |a| a.is_a?(LighthouseUser) }
    @token = @user.token || args.detect { |a| a.is_a?(String) }

    @api_url = "https://#{@user.namespace}.lighthouseapp.com"
    
    super()

    @http.headers['X-LighthouseToken'] = @token
  end

  def recently_updated_tickets(project_id, page=1, limit=100)
    response = @http.get(
      "/projects/#{project_id}/tickets.json",
      limit: limit,
      page:  page,
      q:     'sort:updated'
    ).body

    parse_response(response)[:tickets].collect { |t| t[:ticket] }
  end

  def ticket(project_id, ticket_id)
    response = @http.get("/projects/#{project_id}/tickets/#{ticket_id}.json").body
    parse_response(response)[:ticket]
  end

  def user
    response = @http.get("/users/#{@user.lighthouse_id}.json").body
    parse_response(response)[:user]
  end
end