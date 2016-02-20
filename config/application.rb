require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Motd
  class Application < Rails::Application  
  end
end
