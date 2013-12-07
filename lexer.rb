#Splits a file into a token stream
class Lexer
	def initialize file
		@whole = ""
		@stream = []

		text = File.open file, 'r'
		text.each do |line|
			@whole += line + " "
		end
	end

	def clearDoubleSpace
		@whole.gsub! "  ", " "
	end

	def clearTab
		@whole.gsub! "\t", " "
	end

	def clearReturn
		@whole.gsub! "\n", " "
	end

	def seperate
		clearTab
		clearReturn
		clearDoubleSpace
		@stream = @whole.split ' '
	end

	def final
		seperate
		return @stream
	end
end
