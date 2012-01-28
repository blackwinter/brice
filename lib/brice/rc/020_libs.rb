# Load libraries

brice 'libs' => nil do |config|

  unless config.empty?
    config.each { |lib| brice_require lib }
  else
    %w[
      pp
      yaml
      tempfile
      benchmark
      backports
      what_methods
      irb/completion
    ].each { |lib| brice_require lib, true }
  end

end
