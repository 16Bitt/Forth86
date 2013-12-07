require '~/prog/scrap/nametable.rb'
require '~/prog/scrap/lexer.rb'

class Spreader
	def initialize file, out = "a.out", last = "0",label = 0, names = [], values = []
		@stream = Lexer.new(file).final
		@pc = 0
		@names = NameTable.new names, values
		@file = ""
		@table = ""
		@last = last
		@label = label
		@out = out

		doAll
		final
	end

	def current
		return @stream[@pc]
	end

	def read
		ret = current
		@pc += 1

		return ret
	end

	def addWord name, flag = nil
		@table += "\nFLBL#{@label}:"
		@table += "\n\tdw #{@last}\n\tdb \"#{name}\",0"
		
		if flag
			@table += "\n\tCALL 0:lbl#{@label}\n\tNEXT"
		end

		@names.add name, @label
		@last = "FLBL#{@label}"
		
		@label += 1
	end

	def nativeWord
		name = read
		addWord name, true
		@file += "\nlbl#{@label - 1}:"
		while true
			key = read

			if key == "}"
				@file += "\n\tNEXT"
				break
			end

			case key
				when "T"
					@file += "\t"
				when "N"
					@file += "\n"
				when "NT"
					@file += "\n\t"
				when "FWORD"
					@file += "CALL 0:lbl#{@names.get read}"
				else
					@file += key + " "
			end
			
			
		end
	end

	def forthWord
		name = read
		addWord name
		
		@table += "\nlbl#{@label - 1}:"

		while true
			key = read
			
			if key == ";"
				break
			elsif number? key
				@table += "\n\tdb PUSHVAL\n\tdw #{key}\n\tCALL 0:CPUSHF\n\t"
			else
				@table += "\n\tCALL 0:lbl#{@names.get key}"
			end
		end

		@table += "\n\tNEXT"
	end

	def doAll
		while @pc < @stream.length
			key = read
			if key == ":"
				forthWord
			elsif key == "{"
				nativeWord
			else
				abort "Unrecognized token '#{key}'"
			end
		end
	end

	def final
		begin
			file = File.new @out, 'w'
			file.puts @file
			file.puts @table
			@names.save @out + ".names", @out + ".values"
			file = File.open @out + ".last", 'w'
			file.puts @label
			file.close

			puts "LAST LABEL: lbl" + (@label - 1).to_s
		rescue Exception => e
			abort "File Write Error"
		end
	end

	def number? str
		for i in 0...str.length
			if ((str[i] < '0') or (str[i] > '9'))
				return nil
			end
		end

		return true
	end
end
