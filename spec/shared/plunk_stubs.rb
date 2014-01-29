shared_context "plunk stubs" do
  before :each do
    Plunk.any_instance.stub(:timestamp_field).and_return(:@timestamp)
  end
end
