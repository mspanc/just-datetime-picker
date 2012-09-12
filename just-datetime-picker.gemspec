# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Marcin Lewandowski"]
  gem.email         = ["marcin@saepia.net"]
  gem.description   = %q{Gem that just creates date/time picker in active admin and propably any other formtastic-based form}
  gem.summary       = %q{Gem that just creates date/time picker in active admin and propably any other formtastic-based form}
  gem.homepage      = "https://github.com/saepia/just-datetime-picker"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "just-datetime-picker"
  gem.require_paths = ["lib"]
  gem.version       = '0.0.3'
  gem.add_dependency 'formtastic', '>= 2.0.0'
end
