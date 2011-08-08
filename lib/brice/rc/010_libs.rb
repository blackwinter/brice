# Load libraries

brice 'libs' => nil do |config|

  (config.empty? ? %w[
    yaml
    tempfile
    benchmark
    backports
    what_methods
  ] : config).each { |lib| brice_require lib }

end
