#!/usr/bin/ruby

###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Johnny Gaddis
# JohnnyGaddis777@gmail.com
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "Johnny Gaddis"

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		IO.foreach(file_name) do |line|
			#Step 1: clear out everything before the title
			title = line.sub(/.*>/, "")
			#Step 2: clear out everything after the title
			title.sub!(/(\(|\[|\{|\\|\/|_|-|:|"|`|\+|=|\*|feat\.).*/, "")
			#Step 3: remove any and all punctuation
			title.gsub!(/(\?|\¿|\!|\¡|\.|\;|\&|\@|\%|\#|\|)/, "")
			#Step 4: filter out non english chars
			#if /\w| |'/ == line
			#else

			#Step 5: set to lowercase
			title.downcase!
			puts title
		end

		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])

	# Get user input
end

if __FILE__==$0
	main_loop()
end
