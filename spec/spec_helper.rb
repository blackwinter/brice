require 'brice'
require 'tempfile'

RSpec.configure { |config|
  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }

  config.before(:each) { open_tempfile }
  config.after(:each) { close_tempfile }

  config.include(Module.new {
    def open_tempfile
      @temp = Tempfile.open("wirble_spec_#{object_id}_temp")
      @path = path = @temp.path

      Kernel.at_exit { File.unlink(path) if File.file?(path) }
    end

    def close_tempfile
      @temp.close(true) if @temp
    end
  })
}
