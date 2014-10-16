require 'spec_helper'

describe Slack do
  describe ".post" do
    it "should return HTTP request for Slack" do
      VCR.use_cassette('slack') do
        request = Slack.post("test")

        expect(request).to be_a(Faraday::Response)
      end
    end
  end

  describe ".token" do
    it "should return webhook token for Slack" do
      token = Slack.token

      expect(token).to be_a(String)
    end
  end
end
