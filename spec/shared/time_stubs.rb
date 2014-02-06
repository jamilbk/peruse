require 'timecop'

shared_context "time stubs" do
  before do
    Timecop.freeze(Time.local(2012))
    @time = Time.now
  end

  after do
    Timecop.return
  end
end
