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

# Function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		IO.foreach(file_name, encoding: "utf-8") do |line|
			title = cleanup_title(line)
			# If the title is valid continue
			if title != nil
				# Split the title into words
				words = title.split(" ")
				w_index = 0
				# Remove the stop words
				words = words - %w{a an and by for from in of on or out the to with}
				# If there is more than one word in a title add to biagram
				if words.length > 1
					words.each do |w|
						# If there is no base word add it
						if $bigrams[w] == nil
							$bigrams[w] = Hash.new
							$bigrams[w][words[w_index + 1]] = 1
						# Else if there is no word following the word add it
						elsif $bigrams[w][words[w_index + 1]] == nil
							$bigrams[w][words[w_index + 1]] = 1
						# Else increment the count of the word following
						else
							$bigrams[w][words[w_index + 1]] += 1
						end
						w_index += 1
						# Don't include the last word in the title
						if w_index > words.length - 2
							break
						end
					end
				end
			end
		end
		puts "Finished. Bigram model built.\n"
	rescue
		raise
		STDERR.puts "Could not open file"
		exit 4
	end
end

# Most common word generator
def mcw(word)
		if $bigrams[word] != nil
			mcw_num = 0
			mcw_key = nil
			# For each key in the biagram count the number of times a word after it occurs
			$bigrams[word].keys.each do |key|
				if $bigrams[word][key] > mcw_num
					mcw_num = $bigrams[word][key]
					mcw_key = key
				end
			end
			return mcw_key
		end
		return nil
end

# Create title
def create_title(word)
	return_title = word
	temp = word
	counter = 0
	# While the count is under 20 add the mcw of the previous word to the title
	while mcw(temp) != nil and counter < 19
		return_title += " " + mcw(temp)
		temp = mcw temp
		counter += 1
	end
	return return_title
end

# Create a title based on randomization
def create_title2(word)
	return_title = word
	temp = word
	# Use randomness to create a title
	while rand_word(temp) != nil
		return_title += " " + rand_word(temp)
		temp = rand_word temp
	end
	return return_title
end

# Random word generator
def rand_word(word)
	if $bigrams[word] != nil
		# Select a random key
		return $bigrams[word].keys[rand($bigrams[word].keys.length)]
	end
	return nil
end

# Cleanup title
def cleanup_title(line)
	begin
		# Step 1: clear out everything before the title
		temp_title = line.sub(/.*>/, "")
		# Step 2: clear out everything after the title
		temp_title.sub!(/(\(|\[|\{|\\|\/|_|-|:|"|`|\+|=|\*|feat\.).*/, "")
		# Step 3: remove any and all punctuation
		temp_title.gsub!(/(\?|\¿|\!|\¡|\.|\;|\&|\@|\%|\#|\|)/, "")
		# Step 4: filter out non english chars
		if temp_title =~ /^[\w\s']+\n/
			# Step 5: set to lowercase
			temp_title.downcase!
			title = nil
			title = temp_title if not temp_title == nil
		end
		return title
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

	# Process the file
	process_file(ARGV[0])

	# Get user input and creates a title based on said input (q to quit)
	print "Enter a word [Enter 'q' to quit]:"
	args = $stdin.gets.chomp.downcase
	while args != "q"
		puts create_title2(args)
		print "Enter a word [Enter 'q' to quit]:"
		args = $stdin.gets.chomp.downcase
	end

end

if __FILE__==$0
	main_loop()
end
