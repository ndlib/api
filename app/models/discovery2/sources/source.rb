class Discovery2::Sources::Source
  attr_reader :record_id, :record

  def initialize(record_id, record)
    @record_id = record_id
    @record = record
  end

  def self.render_classes
    [
      Discovery2::Sources::Aleph,
      Discovery2::Sources::CRL,
      Discovery2::Sources::Hathi,
      Discovery2::Sources::Law,
      Discovery2::Sources::PrimoCentral,
    ]
  end

  def to_hash
    return {} if !valid?

    return {
      id: source.id,
      type: source.type,
      url: source.url,
      source_id: source.source_id,
      title: source.title
    }
  end

  def include_this_source?
    source_class && source.include_this_source?
  end


  private

  def valid?
    source_class
  end

  def source
    @source ||= source_class.new(record_id, record)
  end

  def source_class
    return @source_class if @source_class
    self.class.render_classes.each do |klass|
      if klass.can_process_record?(record_id)
        @source_class = klass
        return klass
      end
    end

    return false
  end
end
