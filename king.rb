class King < Piece

  def initialize(y,x,color,board)
    super
  end

  def name
    name = self.color == :W ? "w" : "b"
  end

  def valid_move_dir?(move_y,move_x)
    true
  end
end