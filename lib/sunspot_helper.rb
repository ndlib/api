module SunspotHelper

  def self.included(base)
    base.class_eval do
      extend Sunspot::Rails::Searchable::ActsAsMethods
      Sunspot::Adapters::DataAccessor.register(DataAccessor, base)
      Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, base)
    end
    base.extend ClassMethods
  end

  class IndexException < StandardError
    class MissingAttribute < IndexException; end
  end
  


  module ClassMethods

    def index(index_obj)
      if index_obj.is_a? Array
        Sunspot.index!(index_obj)
      else
        Sunspot.index!(self)
      end
    end

  end

  def index_exception
        error_string = ''
        self.errors.first.each do |e|
          error_string += ' ' + e.to_s
        end
        raise SunspotHelper::IndexException::MissingAttribute, '[ERROR] Error indexing record for class ' + self.class.to_s + ':' + error_string
  end


  class InstanceAdapter < Sunspot::Adapters::InstanceAdapter

    def id
      @instance.id
    end

  end

  class DataAccessor < Sunspot::Adapters::DataAccessor

    def load(id)
      logger.debug(@clazz)
      criteria(id).first
    end


    def load_all(ids)
      criteria(ids)
    end


    private

    def criteria(id)
      @clazz.criteria.id(id)
    end

  end
end
