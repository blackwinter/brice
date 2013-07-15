# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "brice"
  s.version = "0.2.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2013-07-15"
  s.description = "Extra cool IRb goodness for the masses"
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/brice.rb", "lib/brice/colours.rb", "lib/brice/config.rb", "lib/brice/dsl.rb", "lib/brice/history.rb", "lib/brice/init.rb", "lib/brice/loud.rb", "lib/brice/rc/010_added_methods.rb", "lib/brice/rc/020_libs.rb", "lib/brice/rc/030_history.rb", "lib/brice/rc/040_colours.rb", "lib/brice/rc/050_shortcuts.rb", "lib/brice/rc/060_init.rb", "lib/brice/rc/070_prompt.rb", "lib/brice/rc/080_rails.rb", "lib/brice/rc/090_devel.rb", "lib/brice/really_loud.rb", "lib/brice/shortcuts.rb", "lib/brice/version.rb", "COPYING", "ChangeLog", "README", "Rakefile", "TODO", "spec/brice/history_spec.rb", "spec/spec_helper.rb", ".rspec"]
  s.homepage = "http://github.com/blackwinter/brice"
  s.licenses = ["AGPL"]
  s.rdoc_options = ["--charset", "UTF-8", "--line-numbers", "--all", "--title", "brice Application documentation (v0.2.8)", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.5"
  s.summary = "Extra cool IRb goodness for the masses"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-nuggets>, [">= 0.5.2"])
    else
      s.add_dependency(%q<ruby-nuggets>, [">= 0.5.2"])
    end
  else
    s.add_dependency(%q<ruby-nuggets>, [">= 0.5.2"])
  end
end
