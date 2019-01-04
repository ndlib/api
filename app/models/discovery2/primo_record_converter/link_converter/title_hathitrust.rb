class Discovery2::PrimoRecordConverter::LinkConverter::TitleHathitrust < Discovery2::PrimoRecordConverter::LinkConverter::Title
  def matches?
    host =~ /^catalog[.]hathitrust/
  end

  def record_id
    match = path.match(/[^\/]+$/)
    if match.present?
      match[0]
    else
      nil
    end
  end

  def set_title
    link.title = "HathiTrust: #{record_id}"
  end
end
