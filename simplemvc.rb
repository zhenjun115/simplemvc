require "socket"
require "json"
require "pp"

# server = TCPServer.new 3326
# loop do
# 	Thread.start( server.accept ) do |client|
# 		client.puts "Hello !"
# 		client.puts "Time is #{Time.now}"
# 		client.close
# 	end
# end
# TODO: parse config.json
# TODO: parse route.json
# TODO: parse db.json


#load config.json
# File.open( "config/config.json", "r" ) do |file|
# 	config = File.read( file )
# 	config = JSON.parse( config )
# 	pp config
# end

module simplemvc
	CONTROLLER = ""
	MODEL = ""
	VIEW = ""

	def self.route
	end
end
