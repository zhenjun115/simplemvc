require "json"
require "pp"

module SimpleDB

	$view = nil
=begin
	@params: condition, fields, limit, order
	@return: hash
=end

	def self.where( conditions = nil, fields = nil, limit = nil, order = nil )

		conditions = { "=" => { group: "user" }, ">" => {}, ">=" => {}, "<=" => {}, "<" => {}, "OR" => {} }
		fields = [ "name", "group" ]
		limit = 0
		order = ["name", "desc"]
		# load table.json
		self.load( "user" )

		conditions.each do |key, value|

			case key
				# TODO: use block.
				# TODO: format the code.
				# TODO: the code exits many bugs, find the bug and fix them.
			when "="
				conditions["="].each do |key1, value1|
					$view.delete_if { |key2, value2| value2[key1] != value1 }
				end
			when ">" 
				conditions[">"].each do |key1, value1| 
					$view.delete_if { |key2, value2| value2[key1] <= value1 }
				end
			when ">=" 
				conditions[">="].each do |key1, value2|
					$view.delete_if { |key2, value2| value2[key1] < value2 }
				end
			when "<="
				conditions[">="].each do |key1, value2|
					$view.delete_if { |key2, value2| value2[key1] > value2 }
				end 
			# when "AND" 

			# when "OR"

			end
		end
		# pp $view
		# $view.each do |key, value|
			# pp value
		# end

		# limit
		$view.slice( limit, $view.length ) unless limit <= 0

		# fields
		$view.each do |key, value|
			value.delete( key ) unless fields.index( key ) > 0
		end

=begin
		# TODO order
		$view.each do |key, value|
			value.sort_by! { |obj|  }
		end
		order.each do |key| 
		end
=end

	end

=begin
=end

	def self.insert
		#load table.json
		self.load( "user" )

		#insert
		data = { name: "zhenjun", password: "199103", uuid: SecureRandom.uuid }
		data = { $view.size() => data }
		$view.push( data )

		# TODO write data to file
	end

=begin
	@condition
	@data
=end
	# TODO conditions is complex
	def self.delete( condition )
		self.load( "user" )
		
	end

=begin
	@condition
	@data
=end

	def self.update( condition, data )
	end

=begin
	@table load table
	@return json object
=end

	def self.load( table )
		File.open( "db/#{table}_data.json" ) do |file|
			$view = File.read( file )
			$view = JSON.parse( $view )
		end
	end

	def self.testData
		self.load( "user" )
	end
end
SimpleDB::where