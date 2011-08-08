# Basic initialization for IRb

brice 'init' => nil do |config|

  $KCODE = 'u' if RUBY_VERSION < '1.9'

  IRB.conf[:AUTO_INDENT] = true

end
