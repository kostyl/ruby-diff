require_relative 'extensions/array/diffable'

Array.include Extensions::Array::Diffable

module Diff
  def self.text_diff(a, b)
    diff = Diff.new(a, b)
    diff.compute
    Output.new(diff).text_format
  end
end

require_relative 'diff/lcs'
require_relative 'diff/diff'
require_relative 'diff/output'
