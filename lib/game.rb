require_relative 'colorize'

class Game
  def initialize
    file_name = 'google-english-words.txt'
    content = File.open(file_name, 'r') { |data| data.readlines.each(&:chomp!) }
    content.select! { |line| line.length >= 5 && line.length <= 12 }
    @guesses = 1
    @alphabet_array = ('a'..'z').to_a
    @word = content.sample
    @word_array = @word.split('')
    @guess_array = Array.new(@word_array.length, '-')
    @all_guesses = []
    @winner = nil
  end

  def pick_letter
    char = gets.chomp.strip.downcase
    until char.between?('a', 'z') && char.length == 1
      puts 'Please enter a single letter'.red
      char = gets.chomp.strip.downcase
    end
    char
    # if char.length > 1
    #   puts 'Only enter a single letter'.red
    #   pick_letter
    # elsif char.empty?
    #   puts 'Please enter a letter'.red
    #   pick_letter
    # else
    #   char
    # end
  end

  def used?(guess)
    @alphabet_array.include?(guess)
  end

  def logic(guess)
    if @word_array.include?(guess)
      puts "'#{guess}' is a correct guess\n".yellow
      while @word_array.include?(guess)
        @guess_array[@word_array.index(guess)] = guess
        @word_array[@word_array.index(guess)] = '*'
      end
    elsif @guess_array.include?(guess)
      puts "'#{guess}' has been used before\n".red
      new_guess = pick_letter
      logic(new_guess)
    else
      puts "'#{guess}' is not part of the word\n".red
    end
  end

  def win?
    if @word_array.all?('*')
      puts 'You win'.green
      @winner = true
    else
      turn
    end
  end

  def turn
    until @guesses > 12 || !@winner.nil?
      puts @guess_array.join(' ').yellow
      puts "Turn #{@guesses}: Enter a single letter guess from the alphabet\n".light_blue

      guess = pick_letter

      if used?(guess)
        @all_guesses << @alphabet_array.delete(guess)
      else
        puts "'#{guess}' has been used before\n".red
        turn
      end

      @guesses += 1
      print "Guesses #{@all_guesses.join(' ').pink}\n"
      logic(guess)
      win?
    end
  end
end

Game.new.turn

# def turn
#   until $guesses == 12
#     puts 'Enter a single letter guess from the alphabet'
#     round_char = gets.chomp.downcase
#     $alphabet_array.delete(round_char)
#     if $game_word_arr.include?(round_char)
#       while $game_word_arr.include?(round_char) # ["e", "r", "i", "c", "s", "s", "o", "n"].include?('s')
#         p $game_word_arr.index(round_char) # ["e", "r", "i", "c", "s", "s", "o", "n"].index('s') = 4
#         $player_guess[$game_word_arr.index(round_char)] = round_char # player_guess[4] = 's' > ["-", "-", "-", "-", "s", "-", "-", "-"]
#         p $player_guess.join(' ')
#         $game_word_arr[$game_word_arr.index(round_char)] = '*' # ["e", "r", "i", "c", "s", "s", "o", "n"].delete_at(4) > ["e", "r", "i", "c", "s", "o", "n"]
#         p $game_word_arr
#       end
#     else
#       puts 'no'
#     end
#     $guesses += 1
#     if $game_word_arr.all?('*')
#       puts 'You win'
#     else
#       turn
#     end
#   end
# end


# puts 'Enter a single letter guess from the alphabet'
# round_char = gets.chomp.downcase
# p round_char
# $alphabet_array.delete(round_char)
# # p $alphabet_array

# while game_word_arr.include?(round_char) # ["e", "r", "i", "c", "s", "s", "o", "n"].include?('s')
#   p game_word_arr.index(round_char) # ["e", "r", "i", "c", "s", "s", "o", "n"].index('s') = 4
#   player_guess[game_word_arr.index(round_char)] = round_char # player_guess[4] = 's' > ["-", "-", "-", "-", "s", "-", "-", "-"]
#   p player_guess.join(' ')
#   game_word_arr[game_word_arr.index(round_char)] = '*' # ["e", "r", "i", "c", "s", "s", "o", "n"].delete_at(4) > ["e", "r", "i", "c", "s", "o", "n"]
#   p game_word_arr
# end

# if game_word_arr.all?('*')
#   winner = true
# end