require 'gosu'
require_relative 'lib/gof.rb'

class GOFWindow < Gosu::Window
  def initialize(width=640, height=480)
    @width = width
    @height = height
    @background_color = Gosu::Color.new(0xffdedede)
    @alive_color = Gosu::Color.new(0xff464646)
    @dead_color = Gosu::Color.new(0xffededed)

    super @width, @height, false
    self.caption = 'Conway\'s Game of Life'
    self.update_interval = 300

    @cols = @width / 10
    @rows = @height / 10
    @col_width = @width / @cols
    @row_height = @height / @rows

    @world = World.new(@rows, @cols)
    @world.populate
    @game = Game.new(@world)
  end

  def update
    @game.tick!
  end

  def draw_cell(cell)
    color = cell.alive? ? @alive_color : @dead_color
    draw_quad(cell.y * @col_width,              cell.x * @row_height,               color,
              cell.y * @col_width,              cell.x * @row_height + @row_height, color,
              cell.y * @col_width + @col_width, cell.x * @row_height,               color,
              cell.y * @col_width + @col_width, cell.x * @row_height + @row_height, color)
  end

  def draw
    # bright background
    draw_quad(0,      0,       @background_color,
              0,      @height, @background_color,
              @width, 0,       @background_color,
              @width, @height, @background_color)

    # draw living cells
    @game.world.cells.each { |cell| draw_cell(cell) }
  end

  def needs_cursor?
    true
  end
end

GOFWindow.new.show
