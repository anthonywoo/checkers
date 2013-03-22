load 'piece.rb'
class Board

  attr_accessor :whites, :blacks

	def initialize(create_board = true)
    @whites = create_white_pieces if create_board
    @blacks = create_black_pieces if create_board
  end 

  def move_piece(pos1, pos2)
    y1, x1 = pos1[0], pos1[1]
    y2, x2 = pos2[0], pos2[1]
    selected_piece = find_piece(y1, x1)
    captured_piece = nil
    if selected_piece.valid_move?(y2, x2)
      arr = find_leaped_square(pos1, pos2)
      captured_piece = find_piece(arr[0],arr[1]) 
      delete_piece(captured_piece) if captured_piece 
      selected_piece.y, selected_piece.x = y2, x2
    else
      raise "Move was invalid"
    end

    raise "Your piece can still jump" if captured_piece && selected_piece.has_available_jump?
  end

  def check_for_kings
    whites.each do |piece|
      replace_with_king(piece) if piece.y == 0
    end
    blacks.each do |piece|
      replace_with_king(piece) if piece.y == 7
    end
  end

  def replace_with_king(piece) 
    y,x,color = piece.y, piece.x, piece.color
    color_family = color == :W ? self.whites : self.blacks
    king = King.new(y,x,color,self)
    color_family.delete(piece)
    color_family << king
  end


  def find_piece(y,x)
    all_pieces = self.whites + self.blacks
    all_pieces.each do |piece|
      return piece if piece.y == y && piece.x == x
    end
    nil
  end

  def delete_piece(piece)
    selected_pieces = piece.color == :W ? self.whites : self.blacks
    selected_pieces.delete(piece)
  end

  def delete(y,x)
    piece = find_piece(y,x)
    selected_pieces = piece.color == :W ? self.whites : self.blacks
    selected_pieces.delete(piece)
  end

  def create_white_pieces
    pieces = [Piece.new(7,0,:W,self), Piece.new(7,2,:W,self),
             Piece.new(7,4,:W,self), Piece.new(7,6,:W,self),
             Piece.new(6,1,:W,self), Piece.new(6,3,:W,self),
             Piece.new(6,5,:W,self), Piece.new(6,7,:W,self),
             Piece.new(5,0,:W,self), Piece.new(5,2,:W,self),
             Piece.new(5,4,:W,self), Piece.new(5,6,:W,self)]

  end

  def create_black_pieces
    pieces = [Piece.new(0,1,:B,self), Piece.new(0,3,:B,self),
             Piece.new(0,5,:B,self), Piece.new(0,7,:B,self),
             Piece.new(1,0,:B,self), Piece.new(1,2,:B,self),
             Piece.new(1,4,:B,self), Piece.new(1,6,:B,self),
             Piece.new(2,1,:B,self), Piece.new(2,3,:B,self),
             Piece.new(2,5,:B,self), Piece.new(2,7,:B,self)]
  end

  def display
    display = []
    (0..7).each do |i|
      display << ["*","*","*","*","*","*","*","*"]
    end
    self.whites.each {|piece| display[piece.y][piece.x] = piece.name}
    self.blacks.each {|piece| display[piece.y][piece.x] = piece.name}
    print "  0 1 2 3 4 5 6 7"
    print "\n"
    display.each_with_index do |row, index|
      print "#{index}"
      row.each do |piece|
        print " #{piece}"
      end
      print "\n"
    end
  end

  def find_leaped_square(pos1,pos2)
    tempy = [pos1[0], pos2[0]].sort
    leaped_y = (tempy[0]..tempy[1]).to_a[1]
    tempx = [pos1[1], pos2[1]].sort
    leaped_x = (tempx[0]..tempx[1]).to_a[1]
    [leaped_y, leaped_x]
  end

  def dup
    new_board = Board.new(false)
    new_whites = []
    new_blacks = []
    whites.each do |piece|
      new_whites << piece.dup
    end
    blacks.each do |piece|
      new_blacks << piece.dup
    end
    new_board.blacks = new_blacks
    new_board.whites = new_whites
    new_board
  end


end