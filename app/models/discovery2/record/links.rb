class Discovery2::Record::Links
  LINK_ARRAYS = [:table_of_contents, :finding_aids, :reviews, :add_links, :request_links]
  attr_reader :institutions_hash

  def initialize
    @institutions_hash = {}
    LINK_ARRAYS.each do|method|
      instance_variable_set("@#{method}", Discovery2::Record::LinkArray.new)
    end
  end

  LINK_ARRAYS.each do|method|
    define_method(method) do
      instance_variable_get("@#{method}")
    end
  end

  def institution(institution_code)
    institution_code = formatted_code(institution_code)
    institutions_hash[institution_code] ||= Discovery2::Record::InstitutionLinks.new(institution_code)
  end

  def formatted_code(institution_code)
    Discovery2::Institution.format_code(institution_code)
  end

  def institutions
    institutions_hash.values
  end

  def institutions_to_hash
    @institutions_to_hash ||= {}.tap do |hash|
      institutions_hash.each do |code, institution|
        hash[code] = institution.to_hash
      end
    end
  end

  def to_hash
    @to_hash ||= {}.tap do |hash|
      hash[:institutions] = institutions_to_hash
      LINK_ARRAYS.each do |method|
        hash[method] = send(method).link_hashes
      end
    end
  end

  def to_json
    to_hash.to_json
  end
end
