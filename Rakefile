require %q{lib/brice/version}

begin
  require 'hen'

  Hen.lay! {{
    :rubyforge => {
      :project => %q{prometheus},
      :package => %q{brice}
    },

    :gem => {
      :version      => Brice::VERSION,
      :summary      => %q{Extra cool IRb goodness for the masses},
      :files        => FileList['lib/**/*.rb'].to_a,
      :extra_files  => FileList['[A-Z]*'].to_a,
      :dependencies => [['ruby-nuggets', '>= 0.5.0']]
    }
  }}
rescue LoadError
  abort "Please install the 'hen' gem first."
end

### Place your custom Rake tasks here.
