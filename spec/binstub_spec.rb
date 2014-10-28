require 'open3'

describe 'binstub' do
  it 'should execute a valid query from stdin' do
    result = ""

    Open3.popen3(
      "bin/peruse",
      "-h localhost,127.0.0.1",
      "-s 1",
      "-r",
      "-d",
      "-t timestamp"
    ) do |stdin, stdout, stderr|
      stdin.puts "last 1w"
      stdin.close
      result = stdout.read.chomp
    end
      
    expect(result).to be_present
  end

  it 'should not allow invalid options' do
    exit_status = -1 

    Open3.popen3("bin/peruse", "-z") do |stdin, stdout, stderr, thread|
      exit_status = thread.value.exitstatus
    end


    expect(exit_status).to eq 1
  end
end
