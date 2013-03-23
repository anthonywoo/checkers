class Player

  attr_accessor :board
  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
  end

  def move(current_turn)
    input = gets.chomp 
    input = transform_input(input) #11 22 33 44 = [[1,1],[2,2],[3,3],[4,4]
    raise "You can only move your own piece" unless selected_piece(input[0]).color == current_turn
    if valid_sequence?(input)
      (input.length-1).times do |i| 
        last_check = i == input.length-2 ? true : false
        self.board.move_piece(input[i], input[i+1], last_check)
      end
    end
  end
 
  def transform_input(input) #11 22 33 44 = [[1,1],[2,2],[3,3],[4,4]
    $exit_now = true if input == "q"
    input = input.split(" ")
    input = input.map{|x| x.split("")}
    input.each do |ele|
      ele.map!{|x| x.to_i}
    end
    input
  end

  def selected_piece(first_coord)
    y, x = first_coord[0], first_coord[1]
    self.board.find_piece(y,x)
  end

  def valid_sequence?(array) #only check their move sequence - does not check if move is valid
    raise "invalid move sequence" if array.length == 1 #possible move
    if is_a_move?(array[0], array[1]) && array.length == 2
      raise "there is a jump available" if has_valid_jump?(color) #must make jump if there is jump available
    else
      (array.length-1).times do |i| #check all moves are jumps
        raise 'invalid sequence' if is_a_move?(array[i], array[i+1])  
      end
    end
    true
  end

  def has_valid_jump?(current_turn)
    pieces = current_turn == :W ? board.whites : board.blacks
    pieces.each do |piece|
      return true if piece.has_available_jump?
    end
    false
  end

  def is_a_move?(pos1, pos2) #other option would be an "attack"
    y1, x1 = pos1[0], pos1[1]
    y2, x2 = pos2[0], pos2[1]
    (y1 - y2).abs == 1 && (x1 - x2).abs == 1
  end

end