module Plunk
  class ResultSet
    attr_accessor :query, :query_string

    def initialize(filter)
      @query = { query: { filtered: { filter: filter }}}
    end

    def eval
      Plunk.elasticsearch_client.search(
        body: @query.to_json,
        size: Plunk.max_number_of_hits || 10
      ).to_json if @query
    end
  end
end
