# Require the gems
require 'capybara/poltergeist'

# Configure Poltergeist to not blow up on websites with js errors aka every website with js
# See more options at https://github.com/teampoltergeist/poltergeist#customization
#Capybara.register_driver :poltergeist do |app|
  #Capybara::Poltergeist::Driver.new(app, js_errors: false)
#end
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
  )
end
#
#Capybara.register_driver :chrome do |app|
  #Capybara::Selenium::Driver.new(app, :browser => :chrome)
#end

#Capybara.javascript_driver = :chrome
#Capybara.register_driver :selenium do |app|
  #Capybara::Selenium::Driver.new(app, :browser => :chrome)
#end

# Configure Capybara to use Poltergeist as the driver
#Capybara.default_driver = :selenium
Capybara.default_driver = :poltergeist
#Capybara.default_driver = :chrome
