#!/usr/bin/env ruby
#Debug shell

if ARGV.length != 0
	echo = ARGV[0]
else
	echo = "DEBUG> "
end


while true
	print echo

	words = $stdin.gets.chomp

	begin
		if (words == "exit") or (words == "quit")
			break
		else
			eval words
		end
	rescue Exception => e
			puts e
	end
end
