class Being
  attr_reader :row, :column, :world
  attr_accessor :alive

  def initialize(world, alive, row, column)
    @row = row
    @column = column
    @alive = alive
    @world = world
  end

  def alive?
    alive
  end

  def neighbours(row, column)
    neighbour_positions.inject([]) do |result, offset|
      row_offset = (row + offset[0]) % world.row_max
      col_offset = (column + offset[1]) % world.col_max
      result << world.ecosystem[row_offset][col_offset]
    end
  end

  def alive_neighbours(row, column)
    neighbours(row, column).select{|cell| cell.alive? }.count
  end

  def to_s
    alive? ? "0" : "-"
  end

  private

  def neighbour_positions
    [[0,1],[0,-1],[1,0],[-1,0],[-1,-1],[-1,1],[1,-1],[1,1]]
  end
end
