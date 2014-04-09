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
    files = api.pull_request_files(path)
    record.commits += files.length

    files.each do |file|
      record.file_additions += file[:additions]
      record.file_deletions += file[:deletions]
      record.file_changes   += file[:changes]
    end
  end

  def update_merged(path)
    record.merged = api.pull_request_merged(path)
  end
end