class Discovery2::RecordRequest < Discovery2::BaseRecordRequest

  def record_identifiers
    record.identifiers[:record_ids]
  end

  def institution_codes
    parse_institution_codes
  end

  def metadata
    record.display
  end

  def to_json
    record.to_json
  end

  private

  def valid_codes
    ['ndu', 'bci', 'smc', 'hcc']
  end

  def parse_institution_codes
    [].tap do |institution_codes|
      record_identifiers.each do |id|
        id =~ /(\w{3})_aleph(\d+)/
        add_institution_code(Regexp.last_match[1], institution_codes) if Regexp.last_match
      end
    end
  end

  def add_institution_code(regexp, institution_codes)
    inst_string = Discovery2::Institution.format_code(regexp)
    institution_codes.push(inst_string) if valid_codes.include?(regexp)
  end

end
