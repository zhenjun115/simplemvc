# TODO: singleton

class SimpleFILE
	private
	# support file type
	FILE_TYPE_NAME = {
      '.html' => 'text/html',
      '.txt' => 'text/plain',
      '.png' => 'image/png',
      '.jpg' => 'image/jpeg'
  	}

	# @request uri
	# @return type
	def parseFileType( uri )
		type = File.extname( uri )
		return FILE_TYPE_NAME( type )
	end

	# @url request
	# @return path
	def parseFilePath( request, config )
		path = URI.unescape( URI( request ).path )
    	path = File.join( config[:webroot], path )
    	path = File.join( path, 'index.html' ) if File.directory?( path )
    	return path
	end

	protected
	# render file
	def readFile( path )
		# check file exist
		path = File.absolute_path( File.join( config[:webroot], path, file ) )
		# access permission error, example "../root" 
		return nil unless ( Regexp.new( config[:webroot] ) =~ path ) != 0 #TODO: maybe generate errors
		return nil unless !File.directory?( path ) && File.exist?( path )
		# read
		return File.open( path, "rb" )
	end
end