require "rubygems"

$LOAD_PATH << File.join(File.dirname(__FILE__), ".")
$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")
$LOAD_PATH << File.join(File.dirname(__FILE__), "vendor", "rturk", "lib")

require "vendor/rturk/lib/rturk"
require "lib/macrodeck-config"
require "vendor/macrodeck-platform/init"

@cfg = MacroDeck::Config.new(File.join(File.dirname(__FILE__), "config", "macrodeck.yml"))
puts ">>> Starting MacroDeck Platform on #{@cfg.db_url}"
MacroDeck::Platform.start!(@cfg.db_url)
MacroDeck::PlatformDataObjects.define!

Dir.glob("lib/tasks/*.rake").each { |r| import r }
