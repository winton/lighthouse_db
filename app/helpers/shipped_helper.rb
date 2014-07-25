module ShippedHelper

  def time_in_words(num)
    distance_of_time_in_words(num).gsub("about ", "").gsub("less than ", "")
  end
end
