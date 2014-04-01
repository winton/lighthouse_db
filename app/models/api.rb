class Api

  def initialize
    @http = Faraday.new @api_url, ssl: { verify: false } do |conn|
      conn.adapter :excon
    end
  end

  private

  def parse_response(response)
    JSON.parse(response, symbolize_names: true)
  end
end