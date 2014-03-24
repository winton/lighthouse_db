require 'spec_helper'

describe Lighthouse do

  fixtures :lighthouse_users

  let(:lh_user) { lighthouse_users(:default) }

  it "should retrieve information for the current user" do
    VCR.use_cassette('lighthouse') do
      profile = Lighthouse.new(lh_user).user
      profile.should      be_a(Hash)
      profile[:id].should be_a(Fixnum)
    end
  end

  it "should retrieve a list of recently updated tickets" do
    VCR.use_cassette('lighthouse') do
      tickets = Lighthouse.new(lh_user).recently_updated_tickets(6296, 1, 10)
      
      tickets.should        be_an(Array)
      tickets.length.should eq(10)
      tickets.first.should  be_a(Hash)
    end
  end
end