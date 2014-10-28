shared_context "peruse stubs" do
  before :each do
    allow(Peruse).to receive(:timestamp_field).and_return(:@timestamp)
  end
end
