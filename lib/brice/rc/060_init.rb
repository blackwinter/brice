# Basic initialization for IRb

brice 'init' => nil do |config|

  IRB.conf[:AUTO_INDENT]        = true
  IRB.conf[:ECHO_ON_ASSIGNMENT] = true
  IRB.conf[:USE_MULTILINE]      = false

end
