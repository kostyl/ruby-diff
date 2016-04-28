module Extensions
  module Array
    module Diffable
      def indices_by_elements(range = 0...self.count)
        ret = {}
        values_at(range).each_with_index do |element, index|
          if ret[element]
    	      ret[element].push i
          else
    	      ret[element] = [i]
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
        # binary search for replacement point
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

      # def patch(diff)
      #   newary = nil
      #   if diff.difftype == String
      #     newary = diff.difftype.new('')
      #   else
      #     newary = diff.difftype.new
      #   end
      #   ai = 0
      #   bi = 0
      #   diff.diffs.each do |d|
      #     d.each do |mod|
      #     	case mod[0]
      #     	when '-'
      #     	  while ai < mod[1]
      #     	    newary << self[ai]
      #     	    ai += 1
      #     	    bi += 1
      #     	  end
      #     	  ai += 1
      #     	when '+'
      #     	  while bi < mod[1]
      #     	    newary << self[ai]
      #     	    ai += 1
      #     	    bi += 1
      #     	  end
      #     	  newary << mod[2]
      #     	  bi += 1
      #     	else
      #     	  raise "Unknown diff action"
      #     	end
      #     end
      #   end
      #   while ai < self.length
      #     newary << self[ai]
      #     ai += 1
      #     bi += 1
      #   end
      #   return newary
      # end
    end
  end
end
