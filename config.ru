#!/usr/bin/env ruby
# MacroDeck Turk application.

$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")
$LOAD_PATH << File.join(File.dirname(__FILE__), "vendor", "rturk", "lib")

# Ruby libraries.
require "rubygems"
require "builder"
require "sinatra"
require "vendor/rturk/lib/rturk"
require "macrodeck-platform"
require "macrodeck-turk"
require "macrodeck-config"
require "macrodeck-behavior"
require "behaviors/abbreviation_behavior"
require "behaviors/address_behavior"
require "behaviors/day_of_week_behavior"
require "behaviors/description_behavior"
require "behaviors/end_time_behavior"
require "behaviors/event_type_behavior"
require "behaviors/fare_behavior"
require "behaviors/geo_behavior"
require "behaviors/phone_number_behavior"
require "behaviors/postal_code_behavior"
require "behaviors/recurrence_behavior"
require "behaviors/start_time_behavior"
require "behaviors/title_behavior"
require "behaviors/url_behavior"

# Load the config file.
puts ">>> Loading configuration."
cfg = MacroDeck::Config.new(File.join(File.dirname(__FILE__), "config", "macrodeck.yml"))

# Start the MacroDeck platform.
puts ">>> Starting MacroDeck Platform on #{cfg.db_url}"
MacroDeck::Platform.start!(cfg.db_url)
MacroDeck::PlatformDataObjects.define!

puts ">>> MacroDeck Platform started."

# Turk app
map cfg.turk_path_prefix do
	MacroDeck::Turk.configuration = cfg
	MacroDeck::Turk.set :views, File.join(File.dirname(__FILE__), ::MacroDeck::Turk.configuration.view_dir.to_s)
	MacroDeck::Turk.set :public_folder, File.join(File.dirname(__FILE__), "public")

	run MacroDeck::Turk
end

# vim:set ft=ruby
