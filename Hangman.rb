
require "json"
class Hangman
	def initialize(loadOrSave = false, wordCompletion = nil, lettersGuessed = nil, word = nil)
		if (loadOrSave == true) #load
			@wordCompletion = wordCompletion
			@lettersGuessed = lettersGuessed
			@word = word
			puts "Game Loaded!"
		else
			@wordCompletion = Array.new
			@lettersGuessed = Array.new
			lines = File.readlines "5desk.txt"
			randomIndex =  rand(61406)
			lines.each_with_index do |line,index|
				if (index == randomIndex)
					checkSize = true
					while (checkSize)
						if (lines[index].chomp.downcase.size >= 5 && lines[index].chomp.downcase.size <= 12)
							@word = lines[index].chomp.downcase
							puts @word
							checkSize = false;
						end
						puts index
						index += 1;
					end
				end
			end
			for i in 0...@word.size
				@wordCompletion.push('_')
			end
		end
	end

	
	def to_json
	    JSON.dump ({
	      :loadOrSave => true,
	      :wordCompletion => @wordCompletion,
	      :lettersGuessed => @lettersGuessed,
	      :word => @word
	    })
  	end

  	def self.from_json(string)
    	data = JSON.load string
    	self.new(data['loadOrSave'], data['wordCompletion'], data['lettersGuessed'], data['word'])
  	end

	def play
		playing = true
		while (playing)
			playing = !guess

		end
	end

	def guess
		guessing = true
		while (guessing)
			puts "Enter a letter."
			letter = gets.chomp.downcase
			if (!@wordCompletion.include?(letter))
				guessing = false
			end
		end
		if @word.include?(letter) #correct guess
			puts "Correct guess!"
			updateWord(letter)
		else
			puts "Incorrect guess!"
		end
		displayProgress
		return win?
	end

	def updateWord(letter) 
		for i in 0...@word.size
			if (@word[i] == letter)
				@wordCompletion[i] = letter
			end
		end
	end

	def displayProgress
		puts "\n"
		for i in 0...@wordCompletion.size
			print @wordCompletion[i]
		end
		puts "\n"
	end

	def win?
		if (@wordCompletion.include?('_'))
			return false
		else
			return true
		end
	end

end



game = Hangman.new(false)
game.guess
json1 = game.to_json
game.guess
game2 = Hangman.from_json(json1)
game2.guess
