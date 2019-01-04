class Discovery2::PrimoAPIRecord::Holding
  attr_reader :record


  def initialize(record)
    @record = record
  end


  def record_id
    get(:original_id)
  end

  def institution_code
    get(:institution_code)
  end

  def collection_name
    get(:collection)
  end

  def collection_code
    subfield('Z')
  end

  def call_number
    get(:call_number)
  end

  def availability_status_code
    get(:availability_status_code)
  end

  def number_of_items
    subfield('4')
  end

  def multi_volume
    subfield('5')
  end

  def number_of_loans
    subfield('6')
  end

  def to_hash
    {
      record_id: record_id,
      institution_code: institution_code,
      collection_name: collection_name,
      collection_code: collection_code,
      call_number: call_number,
      number_of_items: number_of_items,
      multi_volume: multi_volume,
    }
  end

  private

    def get(field)
      record.send(field)
    end

    def subfield(key)
      record.subfields[key]
    end


  def convert!
    ret = []
    holdings.each do | h |
      hash = {}
      hash[:record_id] = h.original_id
      hash[:institution_code] = h.institution_code
      hash[:collection] = h.collection
      hash[:collection_code] = h.subfields['Z']
      hash[:call_number] = h.call_number
      hash[:availability_status_code] = h.availability_status_code
      hash[:number_of_items] = h.subfields['4']
      hash[:multi_volume] = h.subfields['5']
      hash[:number_of_loans] = h.subfields['6']
    end
  end
end
