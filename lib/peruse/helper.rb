require 'active_support/core_ext'

module Peruse
  class Helper
    def self.combine_subtrees(left, right, op)
      if right[op]
        { op => [left] + right[op] }
      else
        { op => [left, right] }
      end
    end

    def self.query_builder(query_string)
      {
        query: {
          query_string: {
            query: query_string
          }
        }
      }
    end

    def self.filter_builder(filter)
      {
        query: {
          filtered: {
            filter: filter
          }
        }
      }
    end

    def self.limit_builder(limit)
      {
        limit: {
          value: limit
        }
      }
    end

    def self.range_builder(range_min, range_max)
      {
        range: {
          Peruse.timestamp_field => {
            gte: range_min,
            lte: range_max
          }
        }
      }
    end

    def self.regexp_builder(field, regexp, flags=nil)
      {
        regexp: {
          field => {
            value: regexp,
            flags: flags || 'ALL'
          }
        }
      }
    end

    def self.indices_builder(list)
      {
        indices: {
          indices: list
        }
      }
    end

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
  end
end
