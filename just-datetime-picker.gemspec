# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Marcin Lewandowski", "doabit", "Samuel Vega Caballero"]
  gem.email         = ["marcin@saepia.net"]
  gem.description   = %q{Gem that just creates date/time picker in Active Admin forms}
  gem.summary       = %q{Gem that just creates date/time picker in Active Admin forms}
  gem.homepage      = "https://github.com/saepia/just-datetime-picker"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "just-datetime-picker"
  gem.require_paths = ["lib"]
  gem.version       = '0.0.6'
  gem.add_dependency 'formtastic', '>= 2.0.0'
  gem.add_dependency 'activeadmin', '>= 0.4.4'
end
