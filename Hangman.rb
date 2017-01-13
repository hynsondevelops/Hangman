
require "json"
class Hangman
	def initialize
		@wordCompletion = Array.new
		@lettersGuessed = Array.new
		lines = File.readlines "5desk.txt"
		@randomIndex =  rand(61406)
		lines.each_with_index do |line,index|
			if (index == @randomIndex)
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

	def save
		@json = self.to_json
		puts @json
	end

	def load
		@json.from_json
	end

end

game = Hangman.new
game.guess
game.save
game.guess
game.load
game.guess