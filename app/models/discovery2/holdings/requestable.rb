class Discovery2::Holdings::Requestable
  attr_reader :record_id

  def self.call(record_id)
    new(record_id).requestable?
  end

  def initialize(record_id)
    @record_id = record_id
  end

  def requestable?
    code = record_id.scan(/^([a-zA-Z_]*)[0-9]*/).first.first
    ['ndu_aleph', 'smc_aleph', 'hcc_aleph', 'bci_aleph'].include?(code)
  end
end
