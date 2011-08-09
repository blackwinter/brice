# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{brice}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jens Wille}]
  s.date = %q{2011-08-09}
  s.description = %q{Extra cool IRb goodness for the masses}
  s.email = %q{jens.wille@uni-koeln.de}
  s.extra_rdoc_files = [%q{README}, %q{COPYING}, %q{ChangeLog}]
  s.files = [%q{lib/brice.rb}, %q{lib/brice/init.rb}, %q{lib/brice/history.rb}, %q{lib/brice/colours.rb}, %q{lib/brice/version.rb}, %q{lib/brice/shortcuts.rb}, %q{lib/brice/config.rb}, %q{lib/brice/rc/090_devel.rb}, %q{lib/brice/rc/010_added_methods.rb}, %q{lib/brice/rc/020_libs.rb}, %q{lib/brice/rc/030_history.rb}, %q{lib/brice/rc/070_prompt.rb}, %q{lib/brice/rc/040_colours.rb}, %q{lib/brice/rc/050_shortcuts.rb}, %q{lib/brice/rc/060_init.rb}, %q{lib/brice/rc/080_rails.rb}, %q{lib/brice/dsl.rb}, %q{README}, %q{ChangeLog}, %q{Rakefile}, %q{TODO}, %q{COPYING}]
  s.homepage = %q{http://prometheus.rubyforge.org/brice}
  s.rdoc_options = [%q{--line-numbers}, %q{--main}, %q{README}, %q{--all}, %q{--charset}, %q{UTF-8}, %q{--title}, %q{brice Application documentation (v0.2.2)}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{prometheus}
  s.rubygems_version = %q{1.8.7}
  s.summary = %q{Extra cool IRb goodness for the masses}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-nuggets>, [">= 0.5.2"])
    else
      s.add_dependency(%q<ruby-nuggets>, [">= 0.5.2"])
    end
  else
    s.add_dependency(%q<ruby-nuggets>, [">= 0.5.2"])
  end
end
