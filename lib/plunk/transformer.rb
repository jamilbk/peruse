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

    # Regexp
    rule(command: {
      field: simple(:field),
      value: {
        regexp: simple(:regexp)
      }
    }) do
      Helper.regexp_builder(String(field), String(regexp))
    end

    # Value-only
    rule(command: { value: simple(:value) }) do
      Helper.query_builder(String(value))
    end

    rule(command: {
      quantity: simple(:quantity),
      quantifier: simple(:quantifier)
    }) do
      start_timestamp = Helper.time_query_to_timestamp(
        Integer(quantity),
        String(quantifier)
      )

      start_time = Helper.timestamp_format start_timestamp
      end_time = Helper.timestamp_format(Time.now)

      Helper.range_builder(start_time, end_time)
    end

    rule(:negate => subtree(:not)) do
      { not: negate }
    end

    rule(:or => {
      left: subtree(:left),
      right: subtree(:right)
    }) do
      Helper.combine_subtrees(left, right, :or)
    end

    rule(:and => {
      left: subtree(:left),
      right: subtree(:right)
    }) do
      Helper.combine_subtrees(left, right, :and)
    end

  end
end
