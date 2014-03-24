require 'spec_helper'

describe LighthouseUser do

  fixtures :lighthouse_users
  let(:lh_user) { lighthouse_users(:default) }

  it "should update database from recently updated tickets" do
    VCR.use_cassette('lighthouse') do
      lh_user.should_receive(:update_from_api!).with(6296, 1, 10).and_call_original
      lh_user.should_receive(:update_from_api!).with(6296, 2, 10).and_call_original
      lh_user.should_receive(:update_from_api!).with(6296, 3, 10)
      lh_user.update_from_api!(6296, 1, 10)

      assigned = false
      
      LighthouseTicket.count.should eq(20)
      LighthouseTicket.all.each do |ticket|
        ticket.body.should    be_a(String)
        ticket.number.should  be_a(Fixnum)
        ticket.state.should be_a(String)
        ticket.ticket_created_at.should be_a(Time)
        ticket.ticket_updated_at.should be_a(Time)
        ticket.title.should be_a(String)
        ticket.url.should   be_a(String)

        assigned ||= ticket.assigned_lighthouse_user.is_a?(LighthouseUser)
        ticket.lighthouse_user.should be_a(LighthouseUser)
      end

      assigned.should == true
    end
  end

  it "should not go past the first page if last API result is not new" do
    VCR.use_cassette('lighthouse') do
      lh_user.should_receive(:update_from_api!).with(6296, 1, 10).and_call_original
      lh_user.should_receive(:update_from_api!).with(6296, 2, 10).and_call_original
      lh_user.should_receive(:update_from_api!).with(6296, 3, 10)
      lh_user.update_from_api!(6296, 1, 10)
      
      lh_user.should_receive(:update_from_api!).once.and_call_original
      lh_user.update_from_api!(6296, 1, 10)
    end
  end
end
