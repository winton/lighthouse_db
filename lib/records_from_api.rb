module RecordsFromApi

  def create_all(api, records, hash)
    records.each do |record|
      api_record = hash[record[:number]]
      create(api, api_record, record)
    end
  end

  def hash_by_number(records)
    numbers = records.collect { |t| t[:number] }
    records = klass.where(number: numbers)
    Hash[records.map { |t| [ t.number, t ] }]
  end

  def next_page?(records, hash)
    if records.last
      last_record = hash[records.last[:number]]

      if last_record
        last_record.needs_update?(records.last)
      else
        true
      end
    end
  end

  def update(page=1, limit=100)
    puts "Processing page #{page}..." unless Rails.env == "test"

    api, records = recently_updated(page, limit)
    hash         = hash_by_number(records)
    
    create_all(api, records, hash)

    if next_page?(records, hash)
      update(page + 1, limit)
    end
  end
end