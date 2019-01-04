class Discovery2::FullviewRequest < Discovery2::BaseRecordRequest
  def process_record(record)
    Discovery2::RecordSfx.add_links(record, institution_code)
  end
end
