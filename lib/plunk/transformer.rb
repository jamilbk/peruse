require 'parslet'

class Plunk::Transformer < Parslet::Transform

  rule(match: simple(:value)) do
    Plunk::ResultSet.new(query_string: "#{value}")
  end

  rule(
    field: simple(:field),
    value: {
      term: simple(:term),
      extractors: simple(:extractors)
    },
    op: '=') do

    rs = Plunk::ResultSet.new(query_string: "#{field}:#{term}")

    json = JSON.parse rs.eval
    values = Plunk::Elasticsearch.extract_values json, extractors.to_s.split(',') 

    if values.empty?
      Plunk::ResultSet.new
    else
      Plunk::ResultSet.new(query_string: "(#{values.uniq.join(' OR ')})")
    end
  end

  rule(field: simple(:field), value: simple(:value), op: '=') do
    Plunk::ResultSet.new(query_string: "#{field}:#{value}")
  end

  rule(
    search: simple(:query),
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

    end_time = Time.now.utc.to_datetime

    Plunk::ResultSet.new(
      query_string: query,
      start_time: start_time,
      end_time: end_time)
  end
end

