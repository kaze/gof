class Cell
  attr_accessor :alive, :x, :y

  def initialize(x=0, y=0, alive=false)
    @alive = alive
    @x = x
    @y = y
  end

  def alive?
    @alive
  end

  def dead?
    !@alive
  end

  def die!
    @alive = false
  end

  def revive!
    @alive = true
  end
end

class World
  attr_accessor :rows, :cols, :grid, :cells

  def initialize(rows=3, cols=3)
    @rows = rows
    @cols = cols
    @cells = []
    @grid = Array.new(@rows) do |row|
      Array.new(@cols) do |col|
        cell = Cell.new(x=col, y=row)
        @cells << cell
        cell
      end
    end
  end

  # [[Cell, Cell, Cell],
  #  [Cell, Cell, Cell],
  #  [Cell, Cell, Cell]]
  def living_neighbours_of(cell)
    living_neighbours = []

    # detect living neighbour to the NorthWest
    if cell.x > 0 and cell.y > 0
      candidate_north_west = @grid[cell.x - 1][cell.y - 1]
      living_neighbours << candidate_north_west if candidate_north_west.alive?
    end

    # detect living neighbour to the North
    if cell.x > 0 and cell.y <= (@rows - 1)
      candidate_north = @grid[cell.x - 1][cell.y]
      living_neighbours << candidate_north if candidate_north.alive?
    end

    # detect living neighbour to the NorthEast
    if cell.x > 0 and cell.y < (@rows - 1)
      candidate_north_east = @grid[cell.x - 1][cell.y + 1]
      living_neighbours << candidate_north_east if candidate_north_east.alive?
    end

    # detect living neighbour to the East
    if cell.x <= (@cols - 1) and cell.y > 0
      candidate_east = @grid[cell.x][cell.y - 1]
      living_neighbours << candidate_east if candidate_east.alive?
    end

    # detect living neighbour to the West
    if cell.x <= (@cols - 1) and cell.y < (@rows - 1)
      candidate_west = @grid[cell.x][cell.y + 1]
      living_neighbours << candidate_west if candidate_west.alive?
    end

    # detect living neighbour to the SouthWest
    if cell.x < (@cols - 1) and cell.y > 0
      candidate_south_west = @grid[cell.x + 1][cell.y - 1]
      living_neighbours << candidate_south_west if candidate_south_west.alive?
    end

    # detect living neighbour to the South
    if cell.x < (@cols - 1) and cell.y <= (@rows - 1)
      candidate_south = @grid[cell.x + 1][cell.y]
      living_neighbours << candidate_south if candidate_south.alive?
    end

    # detect living neighbour to the SouthEast
    if cell.x < (@cols - 1) and cell.y < (@rows - 1)
      candidate_south_east = @grid[cell.x + 1][cell.y + 1]
      living_neighbours << candidate_south_east if candidate_south_east.alive?
    end

    living_neighbours
  end
end

class Game
  attr_accessor :world, :seeds

  def initialize(world=World.new, seeds=[])
    @world = world
    @seeds = seeds
    @seeds.each do |x, y|
      @world.grid[x][y].alive = true
    end
  end

  def tick!
    next_round_live_cells = []
    next_round_dead_cells = []

    @world.cells.each do |cell|
      neighbours = @world.living_neighbours_of(cell).count
      # rule 1
      if cell.alive? and neighbours < 2
        next_round_dead_cells << cell
      end
      # rule 2
      if cell.dead? and neighbours >= 2 and neighbours <= 3
        next_round_live_cells << cell
      end
      # rule 3
      if cell.alive? and neighbours > 3
        next_round_dead_cells << cell
      end
      # rule 4
      if cell.dead? and neighbours == 3
        next_round_live_cells << cell
      end
    end

    next_round_live_cells.each do |cell|
      cell.revive!
    end

    next_round_dead_cells.each do |cell|
      cell.die!
    end
  end
end


