module Extensions
  module Array
    module Diffable
      def indices_by_elements(range = 0...self.count)
        ret = {}
        values_at(range).each_with_index do |element, index|
          if ret[element]
    	      ret[element].push index
          else
    	      ret[element] = [index]
          end
        end
        return ret
      end

      def replace_next_larger(value, high = nil)
        high ||= count
        if empty? || value > last
          push value
          return high
        end
        
        low = 0
        while low < high
          index = (high + low) / 2
          found = at(index)
          return nil if value == found
          if value > found
    	      low = index + 1
          else
    	      high = index
          end
        end

        self[low] = value

        return low
      end
    end
  end
end
