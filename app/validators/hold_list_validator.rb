class HoldListValidator < ActiveModel::Validator
  def validate(record)
    
    unless record.system_id_list.kind_of?(Array)
      raise Exception, 'Institutional id list parameter must be an array of ids'
    end

    if is_array_empty?(record)
      raise Exception, 'Institutional id list parameter must have at least one value'
    end

    if contains_non_strings?(record)
      raise Exception, 'Institutional id cannot contain non-string values'
    end

  end

  private

  def is_array_empty?(record)
    record.system_id_list.count < 1
  end

  def contains_non_strings?(record)
    non_strings = false
    record.system_id_list.each do |id|
      unless id.kind_of?(String)
        non_strings = true
      end
    end
    non_strings
  end

end
