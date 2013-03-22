load 'board.rb'
require 'pry'
class Game

  attr_accessor :board, :current_turn, :display

  def initialize
    @board = Board.new
    @current_turn = :W
  end

  def valid_sequence?(array) #only check their move sequence - does not check if move is valid
    raise "invalid move sequence" if array.length == 1 #possible move
    if is_a_move?(array[0], array[1]) && array.length == 2
      binding.pry
      raise "there is a jump available" if has_valid_jump?(current_turn) #must make jump if there is jump available
      #return false if has_valid_jump?(current_turn)
    else
      (array.length-1).times do |i| #check all moves are jumps
        #return false if is_a_move?(array[i], array[i+1]) 
        raise 'invalid sequence' if is_a_move?(array[i], array[i+1])  
      end
    end
    true
  end

  def get_user_input
    self.display
    input = gets.chomp 
    input = transform_input(input) #11 22 33 44 = [[1,1],[2,2],[3,3],[4,4]
    dup_board = self.board.dup
    begin
      if valid_sequence?(input)
        (input.length-1).times {|i| self.board.move_piece(input[i], input[i+1])}
      end
      #raise "there is a jump available" if has_valid_jump?(current_turn)
    rescue Exception => e
      puts e.message if e
      self.board = dup_board
    end
    binding.pry
    self.board.check_for_kings
  end

  def has_valid_jump?(current_turn)
    pieces = current_turn == :W ? board.whites : board.blacks
    pieces.each do |piece|
      return true if piece.has_available_jump?
    end
    false
  end

  def transform_input(input)#11 22 33 44 = [[1,1],[2,2],[3,3],[4,4]
    input = input.split(" ")
    input = input.map{|x| x.split("")}
    input.each do |ele|
      ele.map!{|x| x.to_i}
    end
    input
  end

  def is_a_move?(pos1, pos2) #other option would be an "attack"
    y1, x1 = pos1[0], pos1[1]
    y2, x2 = pos2[0], pos2[1]
    (y1 - y2).abs == 1 && (x1 - x2).abs == 1
  end

  def display
    self.board.display
  end

end