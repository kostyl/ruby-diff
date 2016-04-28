require_relative 'extensions/array/diffable'

Array.include Extensions::Array::Diffable

module Diff; end

require_relative 'diff/lcs'
require_relative 'diff/diff'
require_relative 'diff/output'
