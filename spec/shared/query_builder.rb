module QueryBuilder
  def query_builder(query_string)
    {
      query: {
        query_string: {
          query: query_string
        }
      }
    }
  end

  def filter_builder(filter)
    {
      query: {
        filtered: {
          filter: filter
        }
      }
    }
  end

  def range_builder(range_min, range_max)
    {
      range: {
        :@timestamp => {
          gte: range_min,
          gte: range_max
        }
      }
    }
  end
end
