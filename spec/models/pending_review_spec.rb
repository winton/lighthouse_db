require 'spec_helper'

describe PendingReview do
  before(:all) do
    @pending_reviews = PendingReview.older_than_a_day
  end

  describe ".notify" do
    it "should notify Slack when tickets have been pending-review for more than 24 hours" do
      VCR.use_cassette('pending-review') do
        alerts_sent = PendingReview.notify

        expect(alerts_sent).to eq(0)
      end
    end
  end

  describe ".older_than_a_day" do
    it "should return Array of pending reviews older than a day" do
      expect(@pending_reviews).to be_a(Array)
    end
  end

  describe ".send_alerts_for" do
    it "should return number of alerts sent" do
      VCR.use_cassette('pending-review') do
        alerts_sent = PendingReview.send_alerts_for(@pending_reviews)

        expect(alerts_sent).to eq(0)
      end
    end
  end
end
