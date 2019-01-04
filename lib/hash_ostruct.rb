class Hash
  def to_ostruct
    OpenStruct.new {}.tap do |h|
      self.each do |k, v|
        h[k] = case v
               when Hash
                 v.to_ostruct
               when Array
                 v.collect { |i| i.is_a?(Hash) ? i.to_ostruct : i }
               else
                 v
               end
      end
    end
  end
end


