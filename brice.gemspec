# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{brice}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = %q{2008-11-18}
  s.description = %q{Extra cool IRb goodness for the masses}
  s.email = %q{jens.wille@uni-koeln.de}
  s.extra_rdoc_files = ["COPYING", "ChangeLog", "README"]
  s.files = ["lib/brice/init.rb", "lib/brice/version.rb", "lib/brice/dsl.rb", "lib/brice/config.rb", "lib/rc/010_libs.rb", "lib/rc/040_rails.rb", "lib/rc/015_utility_belt.rb", "lib/rc/030_prompt.rb", "lib/rc/050_devel.rb", "lib/rc/020_init.rb", "lib/rc/005_added_methods.rb", "lib/rc/004_wirble.rb", "lib/brice.rb", "COPYING", "README", "ChangeLog", "Rakefile"]
  s.has_rdoc = true
  s.homepage = %q{http://brice.rubyforge.org/brice}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "brice Application documentation", "--charset", "UTF-8", "--main", "README", "--all"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{brice}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Extra cool IRb goodness for the masses}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-nuggets>, [">= 0"])
    else
      s.add_dependency(%q<ruby-nuggets>, [">= 0"])
    end
  else
    s.add_dependency(%q<ruby-nuggets>, [">= 0"])
  end
end
