shared_context "time stubs" do
  before :each do
    @time = Time.parse("01/01/2010 10:00")
    Time.any_instance.stub(:now).and_return(@time)
  end
end
