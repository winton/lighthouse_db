class Lighthouse

  class <<self
    def namespace_and_number_from_ticket_url(url)
      regex = /:\/\/([^\.]+)[\D]+(\d+)/
      url.match(regex).to_a[1..-1]
    end
  end

  def initialize(*args)
    @user = args.detect { |a| a.is_a?(LighthouseUser) }
    token = args.detect { |a| a.is_a?(String) }

    @api_url = "https://#{@user.namespace}.lighthouseapp.com"

    @http = Faraday.new @api_url, ssl: { verify: false } do |conn|
      conn.adapter :excon
    end
    
    @http.headers['X-LighthouseToken'] = @user.token || token
  end

  def memberships
    response = @http.get("/users/#{@user.lighthouse_id}/memberships.json").body
    JSON.parse(response, symbolize_names: true)[:memberships]
  end

  def projects
    response = @http.get("/projects.json").body
    JSON.parse(response, symbolize_names: true)[:projects]
  end

  def recently_updated_tickets(project_id, page=1, limit=100)
    response = @http.get(
      "/projects/#{project_id}/tickets.json",
      limit: limit,
      page:  page,
      q:     'sort:updated'
    ).body

    response = JSON.parse(response, symbolize_names: true)
    response[:tickets].collect { |t| t[:ticket] }
  end

  def ticket(project_id, ticket_id)
    response = @http.get("/projects/#{project_id}/tickets/#{ticket_id}.json").body
    JSON.parse(response, symbolize_names: true)[:ticket]
  end

  def user
    response = @http.get("/users/#{@user.lighthouse_id}.json").body
    JSON.parse(response, symbolize_names: true)[:user]
  end
end