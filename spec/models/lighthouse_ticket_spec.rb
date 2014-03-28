require 'spec_helper'

describe LighthouseTicket do
  
  let(:lh_user) { FactoryGirl.create(:lighthouse_user) }

  describe "#needs_update" do

    it "should determine if a ticket needs to be updated" do
      VCR.use_cassette('lighthouse') do
        api_ticket = Lighthouse.new(lh_user).recently_updated_tickets(6296, 1, 1).first
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

  describe ".hash_tickets_by_numbers" do

    it "should create a hash of tickets by ticket number" do
      hash = (0..9).inject({}) do |hash, number|
        hash[number] = LighthouseTicket.create!(number: number)
        hash
      end
      
      LighthouseTicket.hash_tickets_by_numbers(0..9).should eq(hash)
    end
  end

  describe ".update_all_from_api!" do

    def lighthouse_user_matcher(user)
      user.should               be_a(LighthouseUser)
      user.name.should          be_a(String)
      user.namespace.should     be_a(String)
      user.lighthouse_id.should be_a(Fixnum)
    end

    it "should update database from recently updated tickets" do
      VCR.use_cassette('lighthouse') do
        LighthouseTicket.should_receive(:update_all_from_api!).with(lh_user, 6296, 1, 10).and_call_original
        LighthouseTicket.should_receive(:update_all_from_api!).with(lh_user, 6296, 2, 10).and_call_original
        LighthouseTicket.should_receive(:update_all_from_api!).with(lh_user, 6296, 3, 10)
        LighthouseTicket.update_all_from_api!(lh_user, 6296, 1, 10)

        tickets = LighthouseTicket.all
        tickets.length.should eq(20)

        tickets.each do |ticket|
          ticket.body.should    be_a(String)
          ticket.number.should  be_a(Fixnum)
          ticket.state.should   be_a(String)
          ticket.ticket_created_at.should be_a(Time)
          ticket.ticket_updated_at.should be_a(Time)
          ticket.title.should   be_a(String)
          ticket.url.should     be_a(String)

          lighthouse_user_matcher(ticket.lighthouse_user)

          ticket.lighthouse_events.each do |event|
            event.event.should be_a(String)
            event.state.should be_a(String)
            event.happened_at.should be_a(ActiveSupport::TimeWithZone)
          end
        end

        assigned_users = tickets.map(&:assigned_lighthouse_user).compact
        assigned_users.length.should be > 0

        assigned_users.each do |user|
          lighthouse_user_matcher(user)
        end
      end
    end

    it "should not go past the first page if last API result is not new" do
      VCR.use_cassette('lighthouse') do
        LighthouseTicket.should_receive(:update_all_from_api!).with(lh_user, 6296, 1, 10).and_call_original
        LighthouseTicket.should_receive(:update_all_from_api!).with(lh_user, 6296, 2, 10).and_call_original
        LighthouseTicket.should_receive(:update_all_from_api!).with(lh_user, 6296, 3, 10)
        LighthouseTicket.update_all_from_api!(lh_user, 6296, 1, 10)
        
        LighthouseTicket.should_receive(:update_all_from_api!).once.and_call_original
        LighthouseTicket.update_all_from_api!(lh_user, 6296, 1, 10)
      end
    end
  end
end
