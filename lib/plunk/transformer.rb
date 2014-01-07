require 'parslet'
require 'active_support/core_ext'

module Plunk

  class Helper
    def self.time_query_to_timestamp(int_quantity, quantifier)
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
    end

    def self.timestamp_format(time)
      time.utc.to_datetime.iso8601(3)
    end

    def self.time_range_hash(start_time, end_time)
      {
        start_time: Plunk::Helper.timestamp_format(start_time),
        end_time: Plunk::Helper.timestamp_format(end_time)
      }
    end
  end

  class Transformer < Parslet::Transform

    # last 24h foo=bar
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
      start_time   = Plunk::Helper.time_query_to_timestamp(int_quantity, quantifier)
      end_time     = Time.now

      # recursively apply nested query
      result_set = Plunk::Transformer.new.apply(initial_query)

      json = JSON.parse result_set.eval
      values = Plunk::Utils.extract_values json, extractors.to_s.split(',')

      result_set_params = Plunk::Helper.time_range_hash(start_time, end_time)
      if values.empty?
        result_set_params.merge!(query_string: "#{field}:(#{values.uniq.join(' OR ')})",)
      end
      Plunk::ResultSet.new(result_set_params)
    end

    rule(match: simple(:value)) do
      ResultSet.new(query_string: "#{value}")
    end

    # foo=`bar=baz|field1,field2,field3`
    rule(
      field: simple(:field),
      value: {
        initial_query: subtree(:initial_query),
        extractors: simple(:extractors)
      },
      op: '=') do

      # recursively apply nested query
      result_set = Transformer.new.apply(initial_query)

      json = JSON.parse result_set.eval
      values = Utils.extract_values json, extractors.to_s.split(',')

      if values.empty?
        ResultSet.new
      else
        ResultSet.new(query_string: "#{field}:(#{values.uniq.join(' OR ')})")
      end
    end

    # foo=bar
    rule(field: simple(:field), value: simple(:value), op: '=') do
      ResultSet.new(query_string: "#{field}:#{value}")
    end

    rule(
      timerange: {
        quantity: simple(:quantity),
        quantifier: simple(:quantifier)
      }) do

      int_quantity = quantity.to_s.to_i
      start_time   = Plunk::Helper.time_query_to_timestamp(int_quantity, quantifier)
      end_time     = Time.now

      result_set_params = Plunk::Helper.time_range_hash(start_time, end_time)
      Plunk::ResultSet.new(result_set_params)
    end

    # last 24h
    rule(
      search: simple(:result_set),
      timerange: {
        quantity: simple(:quantity),
        quantifier: simple(:quantifier)
      }) do

      int_quantity = quantity.to_s.to_i
      start_time   = Plunk::Helper.time_query_to_timestamp(int_quantity, quantifier)
      end_time     = Time.now

      result_set_params = Plunk::Helper.time_range_hash(start_time, end_time)
      result_set_params.merge!(query_string: result_set.query_string)
      Plunk::ResultSet.new(result_set_params)
    end

    # last 24h foo=bar baz=fez
    rule(
      sequence(:set)
    ) do
      Plunk::ResultSet.merge(set)
    end
  end
end
