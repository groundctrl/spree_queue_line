Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "spree_queue_line"
  s.version     = "3.0.4"
  s.summary     = "An online queue line for your customers"
  s.description = <<-DESCRIPTION.gsub(/\s+/, " ").strip
    Spree Queue Line allows your customers to reserve the items in their carts
    while completing the order. The item that are in customers' cart will be
    temporary deducted from your stock, and will go back to stock automatically
    after 20 minutes. Note that this gem requires an Active Job compatible queue
    adapter to work properly.
  DESCRIPTION
  s.required_ruby_version = ">= 2.0.0"

  s.authors = ["Prem Sichanugrist", "Vincent Franco", "David Freerksen"]
  s.homepage  = "https://github.com/groundctrl/spree_queue_line"

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = "lib"
  s.requirements << "none"

  s.add_dependency "spree_core", "~> 3.0.4"
  s.add_dependency "spree_notifications"

  s.add_development_dependency "capybara", "~> 2.4"
  s.add_development_dependency "capybara-webkit"
  s.add_development_dependency "coffee-rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "factory_girl", "~> 4.5"
  s.add_development_dependency "ffaker"
  s.add_development_dependency "rspec-rails",  "~> 3.1"
  s.add_development_dependency "sass-rails", "~> 5.0.0.beta1"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
end
