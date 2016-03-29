require_relative 'lib/brice/version'

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{brice},
      version:      Brice::VERSION,
      summary:      %q{Extra cool IRb goodness for the masses},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,
      dependencies: { nuggets: '~> 1.4' },

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
