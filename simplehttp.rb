# TODO: check bugs
class SimpleHTTP
	private 
	@rootDir = "."
	@configDir = "config"
	@configFile = "config.json"

	# default config
	@@webRoot = "/var/www/html"
	@@port = 3000
	
	protected
	# TODO: file permission check
	def env
		@rootDir = Dir.new( @rootDir )

		# config file exist
		if Dir.exist?( @configDir )
			@configDir = Dir.new( @configDir )
		else
			@configDir = Dir.mkdir( @configDir )
		end

		@configFile = File.join( @configDir, @configFile )

		# parse config file
		@configFile = File.new( @configFile ) unless !File.exist?( @configFile )

		@configFile = JSON.parse( @configFile )

		if @configFile['webroot'] == nil
			@configFile['webroot'] = @@webroot
		end

		if @configFile['port'] == nil
			@configFile['port'] = @@port
		end
	end

	def build( request, socket )
		type = SimpleFILE.parseFileType( request )
		path = SimpleFILE.parseFilePath( request, { webroot: @@webRoot } )
		return SimpleFILE.readFile( path )
	end

	def response( file, type, socket )
		if file != nil
	        socket.print "HTTP/1.1 200 OK\r\n" +
	                     "Content-Type: #{type}\r\n" +
	                     "Content-Length: #{file.size}\r\n" +
	                     "Connection: close\r\n"
	        socket.print "\r\n"
	        IO.copy_stream(file, socket)
	      end
	    else
	      message = "File not found\n"
	      socket.print "HTTP/1.1 404 Not Found\r\n" +
	                   "Content-Type: text/plain\r\n" +
	                   "Content-Length: #{message.size}\r\n" +
	                   "Connection: close\r\n"
	      socket.print "\r\n"
	      socket.print message
	    end
	end


	public
	def start
		server = TCPServer.new( "localhost", @@port )
		loop do
			Thread.start( server.accept ) do |client|
				response = build( client.gets.split(" ")[1], client )
				IO.copy_stream( response, client )
				client.close
				Thread.stop
			end
		end
	end

end