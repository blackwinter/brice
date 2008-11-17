# Useful settings when developing Ruby libraries

brice 'devel' => nil do |config|

  $:.unshift('lib') if File.directory?('lib')

end
