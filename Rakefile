require File.expand_path(%q{../lib/brice/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    :gem => {
      :name         => %q{brice},
      :version      => Brice::VERSION,
      :summary      => %q{Extra cool IRb goodness for the masses},
      :author       => %q{Jens Wille},
      :email        => %q{jens.wille@gmail.com},
      :license      => %q{AGPL},
      :homepage     => :blackwinter,
      :dependencies => [['ruby-nuggets', '>= 0.5.2']]
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
