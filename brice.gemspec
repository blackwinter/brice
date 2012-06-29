# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "brice"
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2012-06-29"
  s.description = "Extra cool IRb goodness for the masses"
  s.email = "jens.wille@uni-koeln.de"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/brice.rb", "lib/brice/config.rb", "lib/brice/version.rb", "lib/brice/history.rb", "lib/brice/shortcuts.rb", "lib/brice/rc/030_history.rb", "lib/brice/rc/050_shortcuts.rb", "lib/brice/rc/080_rails.rb", "lib/brice/rc/020_libs.rb", "lib/brice/rc/070_prompt.rb", "lib/brice/rc/010_added_methods.rb", "lib/brice/rc/040_colours.rb", "lib/brice/rc/060_init.rb", "lib/brice/rc/090_devel.rb", "lib/brice/dsl.rb", "lib/brice/colours.rb", "lib/brice/init.rb", "COPYING", "TODO", "ChangeLog", "Rakefile", "README", "spec/spec_helper.rb", "spec/brice/history_spec.rb", ".rspec"]
  s.homepage = "http://prometheus.rubyforge.org/brice"
  s.rdoc_options = ["--charset", "UTF-8", "--line-numbers", "--all", "--title", "brice Application documentation (v0.2.5)", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "prometheus"
  s.rubygems_version = "1.8.24"
  s.summary = "Extra cool IRb goodness for the masses"

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
