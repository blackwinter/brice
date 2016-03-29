# -*- encoding: utf-8 -*-
# stub: brice 0.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "brice".freeze
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jens Wille".freeze]
  s.date = "2016-03-29"
  s.description = "Extra cool IRb goodness for the masses".freeze
  s.email = "jens.wille@gmail.com".freeze
  s.extra_rdoc_files = ["README".freeze, "COPYING".freeze, "ChangeLog".freeze]
  s.files = ["COPYING".freeze, "ChangeLog".freeze, "README".freeze, "Rakefile".freeze, "TODO".freeze, "lib/brice.rb".freeze, "lib/brice/colours.rb".freeze, "lib/brice/config.rb".freeze, "lib/brice/dsl.rb".freeze, "lib/brice/history.rb".freeze, "lib/brice/init.rb".freeze, "lib/brice/loud.rb".freeze, "lib/brice/rc/010_added_methods_.rb".freeze, "lib/brice/rc/020_libs.rb".freeze, "lib/brice/rc/030_history.rb".freeze, "lib/brice/rc/040_colours.rb".freeze, "lib/brice/rc/050_shortcuts.rb".freeze, "lib/brice/rc/060_init.rb".freeze, "lib/brice/rc/070_prompt.rb".freeze, "lib/brice/rc/080_rails.rb".freeze, "lib/brice/rc/090_devel.rb".freeze, "lib/brice/really_loud.rb".freeze, "lib/brice/shortcuts.rb".freeze, "lib/brice/version.rb".freeze, "spec/brice/history_spec.rb".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "http://github.com/blackwinter/brice".freeze
  s.licenses = ["AGPL-3.0".freeze]
  s.post_install_message = "\nbrice-0.4.1 [2016-03-29]:\n\n* To mark default packages as optional, use underscore in addition to question\n  mark, since the latter is not supported on Windows file systems.\n\n".freeze
  s.rdoc_options = ["--title".freeze, "brice Application documentation (v0.4.1)".freeze, "--charset".freeze, "UTF-8".freeze, "--line-numbers".freeze, "--all".freeze, "--main".freeze, "README".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.6.2".freeze
  s.summary = "Extra cool IRb goodness for the masses".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nuggets>.freeze, ["~> 1.4"])
      s.add_development_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<nuggets>.freeze, ["~> 1.4"])
      s.add_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<nuggets>.freeze, ["~> 1.4"])
    s.add_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
