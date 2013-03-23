load 'board.rb'
require 'pry'
class Game

  attr_accessor :board, :current_turn
  attr_reader :display, :p1, :p2

  def initialize
    @board = Board.new
    @current_turn = :W
    @p1 = Player.new(:W, @board)
    @p2 = Player.new(:B, @board)
  end

  def play
    until game_over?
      puts "\n"
      puts "It is #{@current_turn}'s turn"
      self.board.display
      dup_board = self.board.duplicate
      successful_move = false
      begin
        @current_turn == :W ? self.p1.move(current_turn) : self.p2.move(current_turn)
        successful_move = true
      rescue Exception => e
        puts e.message
        exit if $exit_now
        p1.board = dup_board
        p2.board = dup_board
        self.board = dup_board
      end
      next_turn if successful_move
      self.board.check_for_kings
    end
  end

  def next_turn
    @current_turn = @current_turn == :W ? :B : :W
  end

  def game_over?
    board.blacks.empty? || board.whites.empty?
  end

  def display
    self.board.display
  end

end