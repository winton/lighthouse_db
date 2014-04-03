require 'spec_helper'

describe IssuesFromApi do

  let!(:lh_user) { FactoryGirl.create(:lighthouse_user) }
  let(:user)     { FactoryGirl.create(:github_user) }

  subject { IssuesFromApi.new(user) }

  describe "#update" do

    it "should update database from recently updated tickets" do

      VCR.use_cassette('github') do

        subject.should_receive(:update).with(1, 10).and_call_original
        subject.should_receive(:update).with(2, 10).and_call_original
        subject.should_receive(:update).with(3, 10)
        subject.update(1, 10)

        issues = GithubIssue.all
        issues.length.should eq(20)

        issues.each do |issue|
          issue.number.should be_a(Fixnum)
          issue.repo.should   be_a(String)
          issue.state.should  be_a(String)
          issue.title.should  be_a(String)
          issue.url.should    be_a(String)
          issue.body.should   be_a(String)
          issue.commits.should        be_a(Fixnum)
          issue.file_additions.should be_a(Fixnum)
          issue.file_deletions.should be_a(Fixnum)
          issue.file_changes.should   be_a(Fixnum)
          [ TrueClass, FalseClass ].should include(issue.merged.class)

          issue.issue_created_at.should be_a(ActiveSupport::TimeWithZone)
          issue.issue_updated_at.should be_a(ActiveSupport::TimeWithZone)

          issue.github_user.login.should be_a(String)
          issue.github_user.org.should   be_a(String)
        end
      end
    end
  end
end