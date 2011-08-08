# Load libraries

brice 'libs' => nil do |config|

  (config.empty? ? %w[
    pp
    yaml
    tempfile
    benchmark
    backports
    what_methods
    irb/completion
  ] : config).each { |lib| brice_require lib }

end
