class Discovery2::HoldingRequest < Discovery2::BaseRecordRequest
  def process_record(record)
    Discovery2::RecordHolding.new(record).add_holdings
  end
end
