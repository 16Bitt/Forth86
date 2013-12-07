#Name-Value fetch table
class NameTable
	def initialize names = [], values = []
		@names = names
		@values = values
	end

	def is? name
		@names.each do |test|
			if test == name
				return true
			end
		end

		return nil
	end

	def get name
		if not is? name
			abort "Can't 'get' #{name}."
		end

		for index in 0...@names.length
			if @names[index] == name
				return @values[index]
			end
		end

		abort "FATAL: Name was found at 'get', but gone at return"
	end

	def add name, value = nil
		@names.push name
		@values.push value
	end

	def save names, values
		stream = File.open names, 'w'
		stream.puts @names
		stream.close

		stream = File.open values, 'w'
		stream.puts @values
		stream.close
	end
end
