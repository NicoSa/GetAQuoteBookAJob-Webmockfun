require 'rspec'
require 'getaquotebookajob'
require 'capybara/rspec'
require 'webmock/rspec'

Capybara.app = Sinatra::Application
Capybara.register_driver :selenium_ie do |app|
	Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.default_driver = :selenium

WebMock.disable_net_connect!(:allow_localhost => true)
