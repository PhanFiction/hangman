require 'json'

class Hangman
  attr_accessor :answer, :guess, :game_over

  def initialize()
    loaded_file = File.readlines('english_words.txt')
    saved_file = 'output/save.json'
    self.load_game(saved_file)
    random_number = (rand * loaded_file.length).to_i
    @answer = loaded_file[random_number].strip
    @guess = []
    @game_over = false

    initialize_game()
  end

  # mutate the array to display the correct letter
  def check_input(letter)
    update_guess(letter) if self.answer.include?(letter)
    display_game_over if check_word
  end

  def check_word
    # puts " answer: #{@answer}"
    word = self.guess.join("")
    # puts "answer is #{self.answer}, #{word.length} #{self.answer.length}"
    self.game_over = word == self.answer
  end

  def display_correct_words
    puts "Guess: #{self.guess.join(" ")} "
  end

  def display_game_over
    puts "Game Over"
  end

  def save_game
    game_state = {
      answer: @answer,
      guess: @guess,
      game_over: @game_over
    }
    Dir.mkdir('output') unless Dir.exist?('output')
    File.write('output/save.json', JSON.dump(game_state))
  end

  private
  def initialize_game
    self.answer.split('').each_index do |index|
      self.guess[index] = "_"
    end
  end

  # Deserialize the game state from a JSON file
  def self.load_game(file_path)
    if File.exists?(file_path)
      game_state = JSON.parse(File.read(file_path), symbolize_names: true)
      self.answer = game_state[:answer]
      self.guess = game_state[:guess]
      self.game_over = game_state[:game_over]
    else
      puts "No saved game found at #{file_path}"
      return nil
    end
  end

  def update_guess(letter)
    self.guess.each_index do |index|
      # get index of correct answer letter 
      self.guess[index] = letter if self.answer[index] == letter
    end
  end
end

game = Hangman.new()

user_input = ""

while game.game_over == false

  if game.game_over
    game.display_game_over
    break
  end

  print "Type a letter: "
  user_input = gets.chomp

  break if user_input == "quit"
  game.save_game if user_input == 'save game'
  

  game.check_input(user_input) if game.game_over != true
  game.display_correct_words
end