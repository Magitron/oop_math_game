require 'colorize'
require 'pry'
require_relative 'player'

class Game

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @current_player = @player1
  end

  def prompt_name
    puts "Player 1, what is your name?".yellow
    @player1.name = gets.chomp.capitalize
    puts "Player 2, what is your name?".yellow
    @player2.name = gets.chomp.capitalize
  end

  def generate_question
    num1 = rand(1..10)
    num2 = rand(1..10)
    syms = [:+, :-, :*, :/]
    symbol = syms.sample
    if symbol == :/
      num3 = num1 * num2
      @answer = num1
      num1 = num3
    else
      @answer = num1.send(symbol, num2)
    end
    "#{@current_player.name}, what is #{num1} #{symbol} #{num2}?"
  end

  def prompt_player_for_answer
    @input = gets.chomp.to_i
  end

  def verfiy_answer?
    @answer == @input
  end

  def lose_life
    if @current_player == @player1
      @player1.lives -= 1
    else
      @player2.lives -=1
    end
  end

  def score
    if @current_player == @player1
      @player1.score += 1
    else
      @player2.score +=1
    end
  end

  def winner
    if @player1.score> @player2.score
      @winner = @player1.name
    else 
      @winner = @player2.name
    end
  end

  def reset_game
    @player1.score = 0
    @player1.lives = 3
    @player2.score = 0
    @player2.lives = 3
  end

  def turn_switch 
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end

  def newgame
    loop do
      puts "\nWould you like to play again? (y/n)".light_blue
      decision = gets.chomp.downcase
      case decision
      when "yes"
        return true
      when "y"
        return true
      when "no"
        puts "Goodbye!".magenta
        return false
      when "n"
        puts "Goodbye!".magenta
        return false
      else
        puts "Please say y or n"
      end
    end
  end

  def start
    prompt_name
      loop do
        reset_game
        loop do
          puts generate_question.light_blue
          prompt_player_for_answer
          if verfiy_answer?
            score
            puts "Correct!\n ".green
          else
            lose_life
            puts "Wap wap waaaaappp!\n ".red
            puts "Current lives:\n  Player 1: #{@player1.lives}\n  Player 2: #{@player2.lives}.\n ".yellow
          end
          turn_switch
          break if @player1.lives == 0 || @player2.lives == 0
        end
        winner
        system "cowsay 'Game over'"
        puts "\nThe winner is #{@winner}!\n Score:\n  Player 1: #{@player1.score}\n  Player 2: #{@player2.score}".light_magenta
        break unless newgame
    end
  end
end

@game = Game.new

@game.start
