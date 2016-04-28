class Diff::Output
  attr_reader :diff, :lines

  def initialize(diff)
    @diff = diff
    @lines = []
    @a = diff.a
    @b = diff.b
    @diffs = diff.diffs
    @hunk = []
  end

  def text_format
    compute_lines if lines.empty?

    lines.map.with_index do |line, index|
      [index + 1, line[:operation], line[:text]].join("\t")
    end.join("\n")
  end

  private

  attr_reader :a, :b, :diffs, :hunk

  def compute_lines
    a_index = b_index = 0

    diffs.each do |d|
      d.each do |line|
        case line[:from]
        when :a
          while a_index < line[:index]
            push_line_by_index(a_index)
            a_index += 1
            b_index += 1
          end
          push_to_hunk(line)
          a_index += 1
        when :b
          while b_index < line[:index]
            push_line_by_index(a_index)
            a_index += 1
            b_index += 1
          end
          push_to_hunk(line)
          b_index += 1
        end
      end

      push_hunk
    end

    while a_index < a.count
      push_line_by_index(a_index)
      a_index += 1
      b_index += 1
    end

    lines
  end

  def push_line_by_index(index)
    push_line({
      index: index,
      element: a[index]
    })
  end

  def push_line(line)
    lines.push(serialize_line(line))
  end

  def push_to_hunk(line)
    case line[:from]
    when :a
      hunk.push(line)
    when :b
      merge_with_index = nil

      hunk.each_with_index do |hunk_line, index|
        if hunk_line[:from] == :a
          merge_with_index = index
          break
        end
      end

      if merge_with_index
        a_text = hunk[merge_with_index][:element].strip
        hunk[merge_with_index] = {
          from: :both,
          element: [a_text, line[:element].strip].join('|')
        }
      else
        hunk.push(line)
      end
    end
  end

  def push_hunk
    @hunk.each { |line| push_line(line) }
    @hunk = []
  end

  def serialize_line(line)
    {
      operation: operation_by_from(line[:from]),
      text: line[:element].strip
    }
  end

  def operation_by_from(from = nil)
    case from
    when :a then '-'
    when :b then '+'
    when :both then '*'
    else ' '
    end
  end
end
