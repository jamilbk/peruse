require 'active_support/core_ext'

module Plunk
  class Helper
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

    def self.range_builder(range_min, range_max)
      {
        range: {
          :@timestamp => {
            gte: range_min,
            gte: range_max
          }
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

    def self.time_range_hash(start_time, end_time)
      {
        start_time: timestamp_format(start_time),
        end_time: timestamp_format(end_time)
      }
    end
  end
end
