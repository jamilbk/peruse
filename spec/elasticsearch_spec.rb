require 'plunk'
require 'plunk/elasticsearch'

describe Plunk::Elasticsearch do
  before :all do
    @elasticsearch = Plunk::Elasticsearch.new
  end

  context 'test field mapping' do
    it 'should successfully list all fields' do
      fields = @elasticsearch.available_fields
      expect(fields).to be_a Hash
    end
  end
end
