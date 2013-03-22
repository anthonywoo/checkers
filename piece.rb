#load 'king.rb'
class Piece

  attr_accessor :y, :x, :color, :board

  def initialize(y,x,color, board)
    @x = x
    @y = y
    @color = color
    @board = board
  end

  def name
    name = self.color == :W ? "W" : "B"
  end

  def valid_move?(y,x) #y,x is destination
    if is_move?(y,x) && location_has_no_existing_piece?(y,x) && valid_move_dir?(y,x)
      return true
    elsif is_attack?(y,x) && leaped_square_has_enemy?(y,x) && 
          location_has_no_existing_piece?(y,x) && valid_move_dir?(y,x)
      return true
    end
    false
  end

  def inspect
    puts "y = #{@y}, x = #{@x}, color = #{@color}"
  end

  def is_attack?(move_y,move_x)
    (move_y - self.y).abs == 2 && (move_y - self.y).abs == 2
  end

  def is_move?(move_y,move_x)
    (move_y - self.y).abs == 1 && (move_x - self.x).abs == 1
  end

  def possible_jumps
    in_bounds = Proc.new{|x| x[0] > -1 && x[0] < 8 && x[1] > -1 && x[1] < 8}
    move_set = []
    move_set << [self.y + 2, self.x - 2]
    move_set << [self.y - 2, self.x - 2]
    move_set << [self.y + 2, self.x + 2]
    move_set << [self.y - 2, self.x + 2]
    move_set.select(&in_bounds)
  end

  def valid_move_dir?(move_y,move_x)
    case color
    when :W ; move_y - self.y < 0 
    when :B ; move_y - self.y > 0
    end
  end

  #private

  def has_available_jump?
    if possible_jumps
      possible_jumps.each do |jump|
        y,x = jump[0],jump[1]
        return true if valid_move?(y,x)
      end
    end
    false
  end

  def location_has_no_existing_piece?(y,x)
    return true if self.board.find_piece(y,x).nil?
    false
  end

  def leaped_square_has_enemy?(y,x)
    leaped_array = find_leaped_square(y,x)
    leaped_y, leaped_x = leaped_array[0], leaped_array[1]
    enemy_piece = self.board.find_piece(leaped_y, leaped_x)
    return false if enemy_piece.nil? || enemy_piece.color == self.color
    true
  end

  def find_leaped_square(y,x)
    tempy = [y, self.y].sort
    leaped_y = (tempy[0]..tempy[1]).to_a[1]
    tempx = [x, self.x].sort
    leaped_x = (tempx[0]..tempx[1]).to_a[1]
    [leaped_y, leaped_x]
  end
end