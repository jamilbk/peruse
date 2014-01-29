shared_context "time stubs" do
  before :each do
    @time = Time.parse("11/11/2011 11:11")
    Time.stub(:now).and_return(@time)
  end
end
