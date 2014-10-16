class Slack
  class << self
    def post(message)
      payload = {
        "username" => "pending-review",
        "icon_emoji" => ":hammer:",
        "text" => "#{message}"
      }

      @conn = Faraday.new(url: 'https://bleacherreport.slack.com/services/hooks/incoming-webhook')

      @conn.post do |req|
        req.url "?token=#{token}"
        req.headers['Content-Type'] = 'application/json'
        req.body = payload.to_json
      end
    end

    def token
      config = YAML.load open File.join Rails.root, 'config', 'slack.yml'
      config['token']
    end
  end
end
