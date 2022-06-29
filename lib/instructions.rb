require 'colorize'

module Instructions
  def manual
    <<~HEREDOC
    The goal of the game is to try and guess a random word with 5 ~ 12 letters.
    Each turn you will only be allowed to guess a single letter.
    To win all you have to do is guess all the correct letters in the word without making 10 incorrect guesses.
    
    Press #{"1".red} to play a new game
    Press #{"2".red} to load a saved game
    HEREDOC
  end
end
