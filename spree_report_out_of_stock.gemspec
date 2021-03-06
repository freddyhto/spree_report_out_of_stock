# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_report_out_of_stock/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_report_out_of_stock'
  s.version     = SpreeReportOutOfStock.version
  s.summary     = 'Add view to show history of prodcuts out of stock'
  s.description = 'Allow you search between dates when a products ran out of date'
  s.required_ruby_version = '>= 2.2.7'

  s.author    = 'Freddy Tellez'
  s.email     = 'ftellez@acid.cl'
  s.homepage  = 'https://github.com/your-github-handle/spree_report_out_of_stock'
  s.license = 'BSD-3-Clause'

  s.files       = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '>= 3.2.0', '< 5.0'
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'spree_api', spree_version
  s.add_dependency 'spree_backend', spree_version
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'spree_dev_tools'
end
