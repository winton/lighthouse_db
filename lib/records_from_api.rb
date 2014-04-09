module RecordsFromApi

  def create_all(api, api_records, hash)
    api_records.each_with_index do |api_record, i|
      record = hash[url_from_api(api_record)]
      
      next unless !record || record.needs_update?(api_record)
      record = create(api, record, api_record)

      puts "##{i}:\t #{record.class}:\t #{api_record[:number]}:\t #{api_record[:title]}"
    end
  end

  def hash_by_url(records)
    html_urls = records.collect { |t| url_from_api(t) }
    records   = klass.where(url: html_urls)
    Hash[records.map { |t| [ t.url, t ] }]
  end

  def next_page?(api_records, hash)
    last_api = api_records.last

    if last_api
      last_record = hash[url_from_api(last_api)]

      if last_record
        last_record.needs_update?(api_records.last)
      else
        true
      end
    end
  end

  def update(page=1, limit=100)
    puts "\nProcessing page #{page}..." unless Rails.env == "test"

    api, api_records = recently_updated(page, limit)
    hash             = hash_by_url(api_records)
    
    continue = next_page?(api_records, hash)
    create_all(api, api_records, hash)

    update(page + 1, limit) if continue
  end

  def url_from_api(record)
    record[:html_url] || record[:url]
  end
end