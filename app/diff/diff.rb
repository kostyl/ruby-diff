class Diff::Diff
  attr_reader :a, :b, :diffs

  def initialize(a, b)
    @a = a
    @b = b
    @diffs = []
    @batch = []
  end

  def compute
    indexes = Diff::LCS.compute(a, b)

    a_index = b_index = 0

    while a_index < indexes.count
      bline = indexes[a_index]
      if bline
      	while b_index < bline
      	  discardb(b_index, b[b_index])
      	  b_index += 1
      	end
      	match(a_index, b_index)
      	b_index += 1
      else
	      discarda(a_index, a[a_index])
      end
      a_index += 1
    end

    while a_index < a.count
      discarda(a_index, a[a_index])
      a_index += 1
    end

    while b_index < b.count
      discardb(b_index, b[b_index])
      b_index += 1
    end

    match(a_index, b_index)

    diffs
  end

  def match(ai, bi)
    @diffs.push @curdiffs unless @curdiffs.empty?
    @curdiffs = []
  end

  def discarda(i, elem)
    @curdiffs.push ['-', i, elem]
  end

  def discardb(i, elem)
    @curdiffs.push ['+', i, elem]
  end
end
