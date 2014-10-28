module Peruse
  class Utils
    # nested field matcher
    def self.extract_values(hash, keys)
      @vals ||= []

      hash.each_pair do |k, v|
        if v.is_a? Hash
          extract_values(v, keys)
        elsif v.is_a? Array
          v.flatten!
          if v.first.is_a? Hash
            v.each { |el| extract_values(el, keys) }
          elsif keys.include? k
            @vals += v
          end
        elsif keys.include? k
          @vals << v
        end
      end

      return @vals
    end
  end
end
