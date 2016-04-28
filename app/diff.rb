require_relative 'extensions/array/diffable'

Array.include Extensions::Array::Diffable

module Diff; end

require_relative 'diff/lcs'
