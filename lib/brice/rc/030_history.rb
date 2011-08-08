# Configure IRb history support

brice 'history' => 'brice/history' do |config|

  Brice::History.init(config.opt)

end
