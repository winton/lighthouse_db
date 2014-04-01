module RecordsFromApi

  def create_all(api, api_records, hash)
    api_records.each do |api_record|
      record = hash[api_record[:number]]
      create(api, record, api_record)
    end
  end

  def hash_by_number(records)
    numbers = records.collect { |t| t[:number] }
    records = klass.where(number: numbers)
    Hash[records.map { |t| [ t.number, t ] }]
  end

  def next_page?(api_records, hash)
    if api_records.last
      last_record = hash[api_records.last[:number]]

      if last_record
        last_record.needs_update?(api_records.last)
      else
        true
      end
    end
  end

  def update(page=1, limit=100)
    puts "Processing page #{page}..." unless Rails.env == "test"

    api, api_records = recently_updated(page, limit)
    hash             = hash_by_number(api_records)
    
    create_all(api, api_records, hash)

    if next_page?(api_records, hash)
      update(page + 1, limit)
    end
  end
end