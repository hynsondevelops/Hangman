require "set"
require "json"
class Hangman
	def initialize(wordCompletion = nil, lettersGuessed = nil, word = nil)
		loadOrSave = startMenu
		if (loadOrSave == true) #load
			info = JSON.load(load)
			@wordCompletion = info['wordCompletion']
			@lettersGuessed = info['lettersGuessed']
			@word = info['word']
			@turn = info['turn']
			puts "Game Loaded!"
		else
			@wordCompletion = Array.new
			@lettersGuessed = Array.new
			@turn = 0
			lines = File.readlines "5desk.txt"
			randomIndex =  rand(61406)
			lines.each_with_index do |line,index|
				if (index == randomIndex)
					checkSize = true
					while (checkSize)
						if (lines[index].chomp.downcase.size >= 5 && lines[index].chomp.downcase.size <= 12)
							@word = lines[index].chomp.downcase
							checkSize = false;
						end
						index += 1;
					end
				end
			end
			for i in 0...@word.size
				@wordCompletion.push('_')
			end
		end
		displayProgress
	end

	def startMenu
		puts "Welcome to Hangman!"
		puts "Would you like to start a new game (n) or load one (l)?"
		choice = gets.chomp
		if (choice == 'n')
			return false;
		elsif (choice == 'l')
			return true
		end
	end

	def turn
		@turn += 1
		puts "Turn ##{@turn}"
		guess
		displayProgress
		if (lose?)
			return true
		elsif (win?)
			return true
		else 
			return saveOrContinue
		end
	end

	def lose?
		correctGuesses = Set.new
		for i in 0...@wordCompletion.size
			if (@wordCompletion[i] != '_')
				correctGuesses.add(@wordCompletion[i])
			end
		end
		incorrectGuesses = @lettersGuessed.size - correctGuesses.size
		if ((12 - incorrectGuesses) <= 0)
			puts "Out of Guesses."
			puts "The word was #{@word}"
			return true
		else
			puts "#{12 - incorrectGuesses} incorrect guesses left"
			return false
		end
	end

	def saveOrContinue
		puts "Continue guessing (c) or Save game (s)?"
		choice = gets.chomp
		if (choice == 'c')
			return false
		elsif (choice == 's')
			save
			return true
		end
	end

	def save
		puts "Choose a filename"
		filename = gets.chomp
		target = open(filename, 'w')
		target.write(to_json)
		target.close
	end

	def load
		puts "Enter the name of the file to load."
		filename = gets.chomp
		target = open(filename, 'r')
		info = target.gets
		target.close
		return info
	end
	
	def to_json
	    JSON.dump ({
	      :wordCompletion => @wordCompletion,
	      :lettersGuessed => @lettersGuessed,
	      :word => @word,
	      :turn => @turn
	    })
  	end

	def play
		playing = true
		while (playing)
			playing = !turn
		end
	end

	def printLettersGuessed
		puts "\n"
		print "Letters guessed: "
		for i in 0...@lettersGuessed.size
			print "#{@lettersGuessed[i]}, "
		end
		puts "\n"
	end

	def guess
		guessing = true
		while (guessing)
			puts "Enter a letter."
			letter = gets.chomp.downcase
			if (!@wordCompletion.include?(letter) && !@lettersGuessed.include?(letter))
				@lettersGuessed.push(letter)
				guessing = false
			end
		end
		if @word.include?(letter) #correct guess
			puts "Correct guess!"
			updateWord(letter)
		else
			puts "Incorrect guess!"
		end
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
		printLettersGuessed
	end

	def win?
		if (@wordCompletion.include?('_'))
			return false
		else
			puts "Winner! The word was #{@word}"
			return true
		end
	end

end

game = Hangman.new(false)
game.play