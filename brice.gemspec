# -*- encoding: utf-8 -*-
# stub: brice 0.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "brice"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2014-10-31"
  s.description = "Extra cool IRb goodness for the masses"
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["COPYING", "ChangeLog", "README", "Rakefile", "TODO", "lib/brice.rb", "lib/brice/colours.rb", "lib/brice/config.rb", "lib/brice/dsl.rb", "lib/brice/history.rb", "lib/brice/init.rb", "lib/brice/loud.rb", "lib/brice/rc/010_added_methods?.rb", "lib/brice/rc/020_libs.rb", "lib/brice/rc/030_history.rb", "lib/brice/rc/040_colours.rb", "lib/brice/rc/050_shortcuts.rb", "lib/brice/rc/060_init.rb", "lib/brice/rc/070_prompt.rb", "lib/brice/rc/080_rails.rb", "lib/brice/rc/090_devel.rb", "lib/brice/really_loud.rb", "lib/brice/shortcuts.rb", "lib/brice/version.rb", "spec/brice/history_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "http://github.com/blackwinter/brice"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\nbrice-0.4.0 [2014-10-31]:\n\n* Require at least Ruby 1.9.3.\n* Only set prompt if left at default.\n* Default package +added_methods+ now optional.\n\n"
  s.rdoc_options = ["--title", "brice Application documentation (v0.4.0)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.2"
  s.summary = "Extra cool IRb goodness for the masses"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nuggets>, [">= 0"])
      s.add_development_dependency(%q<hen>, [">= 0.8.0", "~> 0.8"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<nuggets>, [">= 0"])
      s.add_dependency(%q<hen>, [">= 0.8.0", "~> 0.8"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<nuggets>, [">= 0"])
    s.add_dependency(%q<hen>, [">= 0.8.0", "~> 0.8"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
