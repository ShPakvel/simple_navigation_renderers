# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_navigation_renderers/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_navigation_renderers"
  spec.version       = SimpleNavigationRenderers::VERSION
  spec.authors       = ["Pavel Shpak"]
  spec.email         = ["shpakvel@gmail.com"]
  spec.description   = %q{simple_navigation_renderers gem adds renderers for Bootstrap 2 and 3. With these renderers you will be able create any bootstrap navigation elements, such as: submenu, navbar-text, divider, header. As well as add icons to menu elements, such as: gliphicons, font-awesome icons, even custom icons. Also you have split option for main menu containing submenu. }
  spec.summary       = %q{simple_navigation_renderers gem adds renderers for Bootstrap 2 and 3. With these renderers you will be able create any bootstrap navigation elements, such as: submenu, navbar-text, divider, header. As well as add icons to menu elements, such as: gliphicons, font-awesome icons, even custom icons. Also you have split option for main menu containing submenu. }
  spec.homepage      = "http://github.com/ShPakvel/simple_navigation_renderers"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "simple-navigation", "~> 3.11"

  spec.add_development_dependency "actionpack"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
