# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application

require ::File.expand_path('../config/environment',  __FILE__)
use Rack::Static, :urls => ['/carrierwave'], :root => 'tmp' # adding this line
run YourApplicationName::Application

# config/initializers/carrierwave.rb
CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp') # adding these...
  config.cache_dir = 'carrierwave' # ...two lines

  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],                        # required
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],                     # required
    :region                 => 'eu-frankfurt'                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'directory'                        # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
