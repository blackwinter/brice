# Load libraries

brice 'libs' => nil do |config|

  libs = config.entries
  libs = %w[
    yaml
    tempfile
    benchmark
    backports
    what_methods
  ] if libs.empty?
  
  libs.each { |lib| brice_require lib }

end
