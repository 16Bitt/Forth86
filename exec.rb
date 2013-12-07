#!/usr/bin/env ruby
require '/home/socash/prog/scrap/beta.rb'

begin
	if ARGV.length == 3
		names = []
		values = []
		last = 0

		file = File.open ARGV[2] + ".names", 'r'
		file.each do |line|
			names.push line.chomp
		end

		file = File.open ARGV[2] + ".values", 'r'
		file.each do |line|
			values.push line.chomp.to_i
		end

		file = File.open ARGV[2] + ".last", 'r'
		file.each do |line|
			last = line.to_i
		end

		file.close

		Spreader.new ARGV[0], ARGV[1], "FLBL" + (last - 1).to_s, last, names, values
	else
		Spreader.new ARGV[0], ARGV[1]
	end
rescue Exception => e
	abort "USAGE: ./exec.rb <INPUT> <OUTPUT> [<PREVIOUS>]"
end
