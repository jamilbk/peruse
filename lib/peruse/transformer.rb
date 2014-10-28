require 'parslet'
require 'chronic'

module Peruse
  class Transformer < Parslet::Transform
    # Base
    rule(command: subtree(:command)) do
      command
    end

    # Field = Value
    rule(
      field: simple(:field),
      value: simple(:value)
    ) do
      Helper.query_builder(
        String(field) + ":" + String(value)
      )
    end

    # Limit
    rule(limit: simple(:limit)) do
      Helper.limit_builder(Integer(limit))
    end

    # Regexp
    rule(
      field: simple(:field),
      value: {
        regexp: simple(:regexp)
      }
    ) do
      Helper.regexp_builder(String(field), String(regexp))
    end

    # Value-only
    rule(value: simple(:value)) do
      Helper.query_builder(String(value))
    end

    # Indices
    rule(indices: simple(:indices)) do
      list = String(indices).split(',').collect { |s| s.strip }
      Helper.indices_builder(list)
    end

    # Last
    rule(last: subtree(:last)) do
      start_time = last
      end_time = Helper.timestamp_format(Time.now)

      Helper.range_builder(start_time, end_time)
    end

    # Window
    rule(
      window_start: subtree(:window_start),
      window_end: subtree(:window_end)
    ) do
      Helper.range_builder(window_start, window_end)
    end

    # Time parts
    rule(datetime: simple(:datetime)) do
      String(datetime)
    end
    rule(
      quantity: simple(:quantity),
      quantifier: simple(:quantifier)
    ) do
      timestamp = Helper.time_query_to_timestamp(
        Integer(quantity).abs, # last -1h same as last 1h
        String(quantifier)
      )

      Helper.timestamp_format timestamp
    end
    rule(chronic_time: simple(:chronic_time)) do
      Helper.timestamp_format Chronic.parse(chronic_time)
    end

    # Negate
    rule(negate: subtree(:not)) do
      { not: negate }
    end

    # Command joining
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
