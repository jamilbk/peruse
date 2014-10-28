module Peruse
  class ResultSet
    attr_accessor :query, :query_string

    def initialize(filter)
      @query = { query: { filtered: { filter: filter }}}
    end

    def eval
      Peruse.elasticsearch_client.search(
        body: @query,
        size: Peruse.max_number_of_hits || 10
      ) if @query
    end
  end
end
