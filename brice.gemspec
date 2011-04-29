# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{brice}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = %q{2011-04-29}
  s.description = %q{Extra cool IRb goodness for the masses}
  s.email = %q{jens.wille@uni-koeln.de}
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/brice.rb", "lib/brice/init.rb", "lib/brice/version.rb", "lib/brice/config.rb", "lib/brice/dsl.rb", "lib/rc/004_wirble.rb", "lib/rc/030_prompt.rb", "lib/rc/005_added_methods.rb", "lib/rc/020_init.rb", "lib/rc/050_devel.rb", "lib/rc/015_utility_belt.rb", "lib/rc/010_libs.rb", "lib/rc/040_rails.rb", "README", "ChangeLog", "Rakefile", "TODO", "COPYING"]
  s.homepage = %q{http://prometheus.rubyforge.org/brice}
  s.rdoc_options = ["--line-numbers", "--main", "README", "--charset", "UTF-8", "--all", "--title", "brice Application documentation (v0.1.1)"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{prometheus}
  s.rubygems_version = %q{1.7.2}
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
