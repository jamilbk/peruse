require 'parslet'
require 'active_support/core_ext'

class Plunk::Transformer < Parslet::Transform

  rule(
    field: simple(:field),
    value: {
      initial_query: subtree(:initial_query),
      extractors: simple(:extractors)
    },
    op: '=',
    timerange: {
      quantity: simple(:quantity),
      quantifier: simple(:quantifier)
    }) do

    int_quantity = quantity.to_s.to_i

    start_time =
      case quantifier
      when 's'
        int_quantity.seconds.ago
      when 'm'
        int_quantity.minutes.ago
      when 'h'
        int_quantity.hours.ago
      when 'd'
        int_quantity.days.ago
      when 'w'
        int_quantity.weeks.ago
      end

    end_time = Time.now


    # recursively apply nested query
    result_set = Plunk::Transformer.new.apply(initial_query)

    json = JSON.parse result_set.eval
    values = Plunk::Elasticsearch.extract_values json, extractors.to_s.split(',') 

    if values.empty?
      Plunk::ResultSet.new(
        start_time: start_time.utc.to_datetime.iso8601(3),
        end_time: end_time.utc.to_datetime.iso8601(3))
        
    else
      Plunk::ResultSet.new(
        query_string: "#{field}:(#{values.uniq.join(' OR ')})",
        start_time: start_time.utc.to_datetime.iso8601(3),
        end_time: end_time.utc.to_datetime.iso8601(3))
    end
  end

  rule(match: simple(:value)) do
    Plunk::ResultSet.new(query_string: "#{value}")
  end

  rule(
    field: simple(:field),
    value: {
      initial_query: subtree(:initial_query),
      extractors: simple(:extractors)
    },
    op: '=') do

    # recursively apply nested query
    result_set = Plunk::Transformer.new.apply(initial_query)

    json = JSON.parse result_set.eval
    values = Plunk::Elasticsearch.extract_values json, extractors.to_s.split(',') 

    if values.empty?
      Plunk::ResultSet.new
    else
      Plunk::ResultSet.new(query_string: "#{field}:(#{values.uniq.join(' OR ')})")
    end
  end

  rule(field: simple(:field), value: simple(:value), op: '=') do
    Plunk::ResultSet.new(query_string: "#{field}:#{value}")
  end

  rule(
    timerange: {
      quantity: simple(:quantity),
      quantifier: simple(:quantifier)
    }) do

    int_quantity = quantity.to_s.to_i

    start_time =
      case quantifier
      when 's'
        int_quantity.seconds.ago
      when 'm'
        int_quantity.minutes.ago
      when 'h'
        int_quantity.hours.ago
      when 'd'
        int_quantity.days.ago
      when 'w'
        int_quantity.weeks.ago
      end

    end_time = Time.now

    Plunk::ResultSet.new(
      start_time: start_time.utc.to_datetime.iso8601(3),
      end_time: end_time.utc.to_datetime.iso8601(3))
  end

  rule(
    search: simple(:result_set),
    timerange: {
      quantity: simple(:quantity),
      quantifier: simple(:quantifier)
    }) do

    int_quantity = quantity.to_s.to_i

    start_time =
      case quantifier
      when 's'
        int_quantity.seconds.ago
      when 'm'
        int_quantity.minutes.ago
      when 'h'
        int_quantity.hours.ago
      when 'd'
        int_quantity.days.ago
      when 'w'
        int_quantity.weeks.ago
      end

    end_time = Time.now

    Plunk::ResultSet.new(
      query_string: result_set.raw_query,
      start_time: start_time.utc.to_datetime.iso8601(3),
      end_time: end_time.utc.to_datetime.iso8601(3))
  end
end

