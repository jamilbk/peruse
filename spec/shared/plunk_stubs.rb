shared_context "plunk stubs" do
  before :each do
    Plunk.stub(:timestamp_field).and_return(:@timestamp)
  end
end
