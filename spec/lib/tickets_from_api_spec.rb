require 'spec_helper'

describe TicketsFromApi do

  let(:lh_user) { FactoryGirl.create(:lighthouse_user) }

  subject { TicketsFromApi.new(lh_user) }

  describe "#hash_by_numbers" do

    it "should create a hash of tickets by ticket number" do
      hash = (0..9).inject({}) do |hash, number|
        hash[number] = LighthouseTicket.create!(number: number)
        hash
      end

      tickets = (0..9).collect do |number|
        { :number => number }
      end

      subject.hash_by_number(tickets).should eq(hash)
    end
  end

  describe "#update" do

    def assigned_lighthouse_user_matcher(obj)
      assigned_users = obj.map(&:assigned_lighthouse_user).compact
      assigned_users.length.should be > 0

      assigned_users.each do |user|
        lighthouse_user_matcher(user)
      end
    end

    def lighthouse_user_matcher(user)
      user.should               be_a(LighthouseUser)
      user.name.should          be_a(String)
      user.namespace.should     be_a(String)
      user.lighthouse_id.should be_a(Fixnum)
    end

    it "should update database from recently updated tickets" do

      VCR.use_cassette('lighthouse') do

        subject.should_receive(:update).with(1, 10).and_call_original
        subject.should_receive(:update).with(2, 10).and_call_original
        subject.should_receive(:update).with(3, 10)
        subject.update(1, 10)

        tickets = LighthouseTicket.all
        tickets.length.should eq(20)

        events = []

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

          events += ticket.lighthouse_events
        end

        assigned_lighthouse_user_matcher(events)
        assigned_lighthouse_user_matcher(tickets)
      end
    end

    it "should not go past the first page if last API result is not new" do
      VCR.use_cassette('lighthouse') do
        subject.should_receive(:update).with(1, 10).and_call_original
        subject.should_receive(:update).with(2, 10).and_call_original
        subject.should_receive(:update).with(3, 10)
        subject.update(1, 10)
        
        subject.should_receive(:update).once.and_call_original
        subject.update(1, 10)
      end
    end
  end
end