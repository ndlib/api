class Resource::Course::SearchArchivesPolicy

  def search_archive?(search_term)
    (!current_terms.include?(search_term))
  end


  def current_terms
    month = Time.now.month
    if month <= 5
      ["#{Time.now.year}00", "#{Time.now.year - 1}20"]
    elsif month <= 8
      ["#{Time.now.year}10", "#{Time.now.year }00"]
    else
      ["#{Time.now.year}20", "#{Time.now.year }10"]
    end
  end

end
