shared_context "plunk stubs" do
  before :each do
    allow(Plunk).to receive(:timestamp_field).and_return(:@timestamp)
  end
end
