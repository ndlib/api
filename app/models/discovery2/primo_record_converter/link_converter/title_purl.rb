class Discovery2::PrimoRecordConverter::LinkConverter::TitlePurl < Discovery2::PrimoRecordConverter::LinkConverter::Title
  def matches?
    host =~ /^eresources[.]library[.]nd[.]edu/ || (host =~ /^(www[.])?library[.]nd[.]edu/ && path =~ /^\/eresources\//)
  end

  def set_title
    link.title = primo_record.display.title.first
  end
end
