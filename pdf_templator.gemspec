# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pdf_templator/version'

Gem::Specification.new do |spec|
  spec.name          = 'pdf_templator'
  spec.version       = PdfTemplator::VERSION
  spec.authors       = ['Genaro Madrid']
  spec.email         = ['genmadrid@gmail.com']

  spec.summary       = 'Write a short summary, because RubyGems requires one.'
  spec.description   = 'Write a longer description or delete this line.'
  spec.homepage      = 'https://github.com/Mifiel/pdf-templator'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'money'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'numbers_and_words'
  spec.add_dependency 'wicked_pdf'
  # 0.12.4 introduced a bug that rendered super a small font
  spec.add_dependency 'slop', '~> 4.6'
  spec.add_dependency 'wkhtmltopdf-binary', '< 0.12.3.1'

  spec.add_development_dependency 'bump', '~> 0.6'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'simplecov', '~> 0.16'
end
