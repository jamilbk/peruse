require 'parslet'

module Plunk
  class Transformer < Parslet::Transform

    # Field = Value
    rule(command: {
      field: simple(:field),
      value: simple(:value)
    }) do
      Helper.query_builder(
        String(field) + ":" + String(value)
      )
    end

    # Value-only
    rule(command: { value: simple(:value) }) do
      Helper.query_builder(String(value))
    end

    rule(:negate => subtree(:not)) do
      { not: negate }
    end

    rule(:or => {
      left: subtree(:left),
      right: subtree(:right)
    }) do
      { or: [left, right] }
    end

    rule(:and => {
      left: subtree(:left),
      right: subtree(:right)
    }) do
      { and: [left, right] }
    end
  end
end
