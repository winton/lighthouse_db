class UpdatePullRequest < Struct.new(:record, :api)

  def update
    url  = record.pull_request[:url]
    path = url.match(/.+\.com(.+)/)[1] rescue nil

    if path
      update_files(path)
      update_merged(path)
    end
  end

  def update_files(path)
    commits = api.pull_request_commits(path)
    files   = api.pull_request_files(path)

    record.commits = commits.length
    record.files   = files.length

    files.each do |file|
      next if file[:filename][0..6] == "vendor/"
      
      record.file_additions += file[:additions]
      record.file_deletions += file[:deletions]
      record.file_changes   += file[:changes]
    end
  end

  def update_merged(path)
    record.merged = api.pull_request_merged(path)
  end
end