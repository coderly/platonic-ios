# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

require 'motion-cocoapods'

require 'ruby_motion_query'

require 'bubble-wrap'
require 'bubble-wrap/location'
require 'bubble-wrap/reactor'

require 'afmotion'

require 'yaml'

FACEBOOK_PRODUCTION_APP_ID = '571685872908504'

task :'build:device' => 'generate_config'
task :'build:simulator' => 'generate_config'

task :generate_config do
  config = YAML.load_file('app/config.yml')
  File.open('app/initializers/environment_config.rb', 'w') do |f|
    f.write("ENVIRONMENT_CONFIG = #{config.inspect}")
  end
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'platonic'

    # Cocoapods
  app.pods do
    pod 'AFNetworking', '~> 2.0'
    pod 'Facebook-iOS-SDK', '~> 3.10.0'
    pod 'RESideMenu', '~> 3.4'
  end

  app.release do
    app.info_plist['environment'] = 'release'
	end

  # Development configuration
  app.development do
    app.info_plist['environment'] = 'development'
	end

 #  app.testflight do
 #    app.info_plist['environment'] = 'staging'
	# end

  # Facebook
  app.info_plist['FacebookAppID'] = FACEBOOK_PRODUCTION_APP_ID
  app.info_plist['CFBundleURLTypes'] = [
    {
      'CFBundleURLSchemes' => ["fb#{FACEBOOK_PRODUCTION_APP_ID}"]
    }
  ]

  app.info_plist['UISupportedInterfaceOrientations'] = ['UIInterfaceOrientationPortrait']

  app.info_plist['UIRequiredDeviceCapabilities'] = ['location-services']

  app.archs['iPhoneOS'] = ['armv7']
end
