# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

prefix = '/handoff'

map prefix do
  run Rails.application
end

map '/' do
  run ->(env) {
    response = Rack::Response.new
    response.redirect("#{prefix}/#{env['REQUEST_PATH']}")
    response.finish
  }
end
