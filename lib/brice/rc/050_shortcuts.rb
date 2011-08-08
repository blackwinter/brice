# Include convenient shortcut methods

brice 'shortcuts' => 'brice/shortcuts' do |config|

  Brice::Shortcuts.init(
    :object => config.object != false,
    :ri     => config.ri     != false
  )

end
