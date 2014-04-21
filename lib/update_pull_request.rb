class UpdatePullRequest < Struct.new(:record, :api)

  attr_accessor :pull_request

  def update
    record.statuses = []
    return unless record.pull_request
    
    url  = record.pull_request[:url]
    path = url.match(/.+\.com(.+)/)[1] rescue nil

    self.pull_request = api.pull_request(path) if path

    if pull_request
      update_comments
      update_files
      update_merged
      update_statuses
    end
  end

  def update_comments
    record.comments        = pull_request[:comments]
    record.review_comments = pull_request[:review_comments]
  end

  def update_files
    record.commits        = pull_request[:commits]
    record.files          = pull_request[:changed_files]
    record.file_additions = pull_request[:additions]
    record.file_deletions = pull_request[:deletions]
  end

  def update_merged
    record.merged              = pull_request[:merged]
    record.merged_github_login = pull_request[:merged_by][:login] rescue nil
  end

  def update_statuses
    url = pull_request[:statuses_url]
    record.statuses = api.ref_statuses(url) if url
  end
end