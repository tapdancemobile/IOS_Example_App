# RestKit Sinatra Testing Server
# Place at Tests/server.rb and run with `ruby Tests/Server.rb` before executing the test suite within Xcode

require 'rubygems'
require 'sinatra'
require 'json'

configure do
  set :logging, true
  set :dump_errors, true
  set :public_folder, Proc.new { File.expand_path(File.join(root, 'Fixtures')) }
end

def render_fixture(filename)
  send_file File.join(settings.public_folder, filename)
end

get '/Offers' do
    render_fixture('offers.json')
end

# Return a 503 response to test error conditions
get '/offline' do
  status 503
end

# Simulate a JSON error
get '/error' do
  status 400
  content_type 'application/json'
  "{f36a311cba6c29ba4c54f0b8c76e6cb733c01e65quot;errorf36a311cba6c29ba4c54f0b8c76e6cb733c01e65quot;: f36a311cba6c29ba4c54f0b8c76e6cb733c01e65quot;An error occurred!!f36a311cba6c29ba4c54f0b8c76e6cb733c01e65quot;}"
end