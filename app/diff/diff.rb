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
      b_line = indexes[a_index]
      if b_line
      	while b_index < b_line
      	  discard_b(b_index)
      	  b_index += 1
      	end
      	match
      	b_index += 1
      else
	      discard_a(a_index)
      end
      a_index += 1
    end

    while a_index < a.count
      discard_a(a_index)
      a_index += 1
    end

    while b_index < b.count
      discard_b(b_index)
      b_index += 1
    end

    match

    diffs
  end

  private

  def match
    diffs.push @batch unless @batch.empty?
    @batch = []
  end

  def discard_a(index)
    @batch.push({
      from: :a,
      index: index,
      element: a[index]
    })
  end

  def discard_b(index)
    @batch.push({
      from: :b,
      index: index,
      element: b[index]
    })
  end
end
