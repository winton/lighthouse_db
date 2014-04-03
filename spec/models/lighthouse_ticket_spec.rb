require 'spec_helper'

describe LighthouseTicket do
  
  let(:lh_user) { FactoryGirl.create(:lighthouse_user) }

  describe "#needs_update" do

    it "should determine if a ticket needs to be updated" do
      VCR.use_cassette('lighthouse') do
        api_ticket = Lighthouse.new(lh_user).recently_updated_tickets(1, 1).first
        updated_at = Time.parse(api_ticket[:updated_at])
        ticket     = LighthouseTicket.create!(ticket_updated_at: updated_at)

        # False check
        ticket.needs_update?(api_ticket).should eq(false)

        # True check
        ticket.ticket_updated_at = updated_at + 1
        ticket.needs_update?(api_ticket).should eq(true)
      end
    end
  end
end
