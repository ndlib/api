class Discovery2::RecordHolding
  attr_reader :record

  def initialize(record)
    @record = record
  end

  def add_holdings
    holdings = []
    record.identifiers[:record_ids].each do | record_id |
      request = Discovery2::Holdings::Request.new(record_id)
      holdings = holdings + request.holdings
    end

    record.holdings = sort_holdings(holdings)
  end

  def sort_holdings(holdings)
    holdings.each_with_object({}) do |h, res|
      res[h.institution] ||= []
      res[h.institution].push(h)
    end
  end
end
