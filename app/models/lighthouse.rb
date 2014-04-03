class Lighthouse < Api

  attr_reader :token

  def initialize(*args)
    @user  = args.detect { |a| a.is_a?(LighthouseUser) }
    @token = @user.token || args.detect { |a| a.is_a?(String) }

    @api_url = "https://#{@user.namespace}.lighthouseapp.com"
    
    super()

    @http.headers['X-LighthouseToken'] = @token
  end

  def recently_updated_tickets(page=1, limit=100)
    response = @http.get(
      "/projects/#{@user.project_id}/tickets.json",
      limit: limit,
      page:  page,
      q:     'sort:updated'
    ).body

    parse_response(response)[:tickets].collect { |t| t[:ticket] }
  end

  def ticket(ticket_id)
    response = @http.get("/projects/#{@user.project_id}/tickets/#{ticket_id}.json").body
    parse_response(response)[:ticket]
  end

  def user(user=nil)
    user   ||= @user
    response = @http.get("/users/#{user.lighthouse_id}.json").body
    parse_response(response)[:user]
  end
end