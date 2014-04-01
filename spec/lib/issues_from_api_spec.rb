require 'spec_helper'

describe IssuesFromApi do

  let(:user) { FactoryGirl.create(:github_user) }

  subject { IssuesFromApi.new(user) }

  describe "#update" do

    it "should update database from recently updated tickets" do

      VCR.use_cassette('github') do

        subject.should_receive(:update).with(1, 10).and_call_original
        subject.should_receive(:update).with(2, 10).and_call_original
        subject.should_receive(:update).with(3, 10)
        subject.update(1, 10)

        tickets = GithubIssue.all
        tickets.length.should eq(20)
      end
    end
  end
end