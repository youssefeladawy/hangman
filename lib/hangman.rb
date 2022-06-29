require_relative 'game'
require_relative 'instructions'

class Hangman
  include Instructions
  def new_or_load
    selection = gets.chomp.to_i
    case selection
    when 1
      Game.new.turn
    when 2
      Game.new.file_select
    else
      puts 'Please select either 1 or 2'
      new_or_load
    end
  end

  def play
    puts manual
    new_or_load
  end
end
