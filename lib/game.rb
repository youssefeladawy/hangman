require_relative 'hangman'
require_relative 'colorize'
require 'yaml'

require 'pry-byebug'
class Game

  @@time = Time.now.strftime("%d-%m-%Y %H-%M")
  def initialize
    file_name = 'google-english-words.txt'
    content = File.open(file_name, 'r') { |data| data.readlines.each(&:chomp!) }
    content.select! { |line| line.length >= 5 && line.length <= 12 }
    @incorrect_guesses = 0
    @alphabet_array = ('a'..'z').to_a
    @word = content.sample
    @word_array = @word.split('')
    @guess_array = Array.new(@word_array.length, '-')
    @all_guesses = []
    @winner = nil
  end

  def save_game
    content = YAML.dump({
      :incorrect_guesses => @incorrect_guesses,
      :alphabet_array => @alphabet_array,
      :word => @word,
      :word_array => @word_array,
      :guess_array => @guess_array,
      :all_guesses => @all_guesses,
      :winner => @winner
    })
    Dir.mkdir('savedir') unless File.exist?('savedir')
    File.open("savedir/#{@@time}.yaml", 'w') { |file| file.write(content) }
  end

  def file_select
    saves = Dir.glob("savedir/*.yaml").sort { |file, after| after <=> file }
    puts 'Please select the number of the save file'
    saves.each_with_index { |file, i| puts "[#{i}] #{file.delete('savedir/')}"}
    selection = gets.chomp.to_i
    load_game(saves[selection])
  end

  def load_game(file)
    content = YAML.load(File.read(file))
    @incorrect_guesses = content[:incorrect_guesses]
    @alphabet_array = content[:alphabet_array]
    @word = content[:word]
    @word_array = content[:word_array]
    @guess_array = content[:guess_array]
    @all_guesses = content[:all_guesses]
    @winner = content[:winner]
    play
  end

  def pick_letter
    puts "Enter a single letter guess from the alphabet\nYou can enter 'save' to save the game for later\n"
    char = gets.chomp.strip.downcase
    until char.between?('a', 'z') && char.length == 1 || char == 'save'
      puts 'Please enter a single letter'.red
      char = gets.chomp.strip.downcase
    end
    if char == 'save'
      save_game
      puts "Your game is now saved as #{@@time}.yaml".yellow
      play_again
    end

    char
  end

  def logic(guess)
    if @alphabet_array.include?(guess)
      @all_guesses << @alphabet_array.delete(guess)

      if @word_array.include?(guess)
        puts "'#{guess}' is a correct guess\n".yellow
        while @word_array.include?(guess)
          @guess_array[@word_array.index(guess)] = guess
          @word_array[@word_array.index(guess)] = '*'
        end
      else
        @incorrect_guesses += 1
        puts "'#{guess}' is not part of the word\n".red
      end

    else
      puts "'#{guess}' has been used before\n".red
      new_guess = pick_letter
      logic(new_guess)
    end
  end

  def win?
    if @word_array.all?('*')
      puts "You Win!".green
      true
    elsif @incorrect_guesses == 10
      puts "You Lost!".red
      puts "secret word was #{@word}"
      true
    else
      false
    end
  end

  def turn_text
    puts @guess_array.join(' ').yellow
    puts "Incorrect Guesses #{@incorrect_guesses}:".light_blue
  end

  def turn
    turn_text

    guess = pick_letter

    print "Guesses: #{@all_guesses.join(' ').pink}\n"

    logic(guess)
  end

  def play
    turn until win?
    play_again
  end

  def play_again
    puts "Would you like to play again \n#{'1-YES'.green} \n#{'2-NO'.red}"
    selection = gets.chomp.to_i
    case selection
    when 1
      Hangman.new.play
    else
      exit
    end
  end
end
