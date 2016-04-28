module Diff::LCS
  def self.compute(a, b)
    a_start = 0
    b_start = 0
    a_finish = a.count - 1
    b_finish = b.count - 1
    ret = []

    # First we prune off any common elements at the beginning
    while (a_start <= a_finish && b_start <= b_finish && a[a_start] == b[b_start])
      ret[a_start] = b_start
      a_start += 1
      b_start += 1
    end

    # now the end
    while (a_start <= a_finish && b_start <= b_finish && a[a_finish] == b[b_finish])
      ret[a_finish] = b_finish
      a_finish -= 1
      b_finish -= 1
    end

    b_matches = b.indices_by_elements(b_start..b_finish)
    thresh = []
    links = []

    a.values_at(a_start..a_finish).each_with_index do |a_element, a_index|
      next unless b_matches[a_element]
      k = nil
      b_matches[a_element].reverse_each do |b_index|
      	if k && (thresh[k] > b_index) && (thresh[k - 1] < b_index)
      	  thresh[k] = b_index
      	else
      	  k = thresh.replace_next_larger(b_index, k)
      	end
      	links[k] = [ (k == 0) ? nil : links[k - 1], a_index, b_index ] if k
      end
    end

    if !thresh.empty?
      link = links[thresh.count - 1]
      while link
      	ret[link[1]] = link[2]
      	link = link[0]
      end
    end

    return ret
  end
end
