require 'rspec'
require_relative '../lib/gof'

describe 'Game of Life' do
  let!(:world) { World.new }

  context 'Cell' do
    subject { Cell.new }
    it 'should be a new Cell object' do
      expect(subject.is_a?(Cell)).to be_truthy
    end

    it 'should respond to proper methods' do
      expect(subject.respond_to?(:alive)).to be_truthy
      expect(subject.respond_to?(:alive?)).to be_truthy
      expect(subject.respond_to?(:dead?)).to be_truthy
      expect(subject.respond_to?(:x)).to be_truthy
      expect(subject.respond_to?(:y)).to be_truthy
      expect(subject.respond_to?(:die!)).to be_truthy
      expect(subject.respond_to?(:revive!)).to be_truthy
    end

    it 'should be dead as default' do
      expect(subject.alive).to eq(false)
    end

    it 'should have coordinates on initialization' do
      expect(subject.x).to eq(0)
      expect(subject.y).to eq(0)
    end
  end

  context 'World' do
    subject { World.new }

    it 'should create a new world object' do
      expect(subject.is_a?(World)).to be_truthy
    end

    it 'should respond to proper methods' do
      expect(subject.respond_to?(:rows)).to be_truthy
      expect(subject.respond_to?(:cols)).to be_truthy
      expect(subject.respond_to?(:grid)).to be_truthy
      expect(subject.respond_to?(:cells)).to be_truthy
      expect(subject.respond_to?(:living_neighbours_of)).to be_truthy
    end

    it 'should create a proper grid on initialization' do
      expect(subject.grid.is_a?(Array)).to be_truthy
      subject.grid.each do |row|
        expect(row.is_a?(Array)).to be_truthy
        row.each do |col|
          expect(col.is_a?(Cell)).to be_truthy
        end
      end
      expect(subject.cells.size).to eq(9)
    end

    it 'should detect a neighbour to the NorthWest' do
      expect(subject.grid[0][0]).to be_dead
      subject.grid[0][0].alive = true
      expect(subject.grid[0][0]).to be_alive
      expect(subject.living_neighbours_of(subject.grid[1][1]).count).to eq(1)
    end

    it 'should detect a neighbour to the North' do
      expect(subject.grid[0][1]).to be_dead
      subject.grid[0][1].alive = true
      expect(subject.grid[0][1]).to be_alive
      expect(subject.living_neighbours_of(subject.grid[1][1]).count).to eq(1)
    end

    it 'should detect a neighbour to the NorthEast' do
      expect(subject.grid[0][2]).to be_dead
      subject.grid[0][2].alive = true
      expect(subject.grid[0][2]).to be_alive
      expect(subject.living_neighbours_of(subject.grid[1][1]).count).to eq(1)
    end

    it 'should detect a neighbour to the East' do
      expect(subject.grid[1][0]).to be_dead
      subject.grid[1][0].alive = true
      expect(subject.grid[1][0]).to be_alive
      expect(subject.living_neighbours_of(subject.grid[1][1]).count).to eq(1)
    end

    it 'should detect a neighbour to the West' do
      expect(subject.grid[1][2]).to be_dead
      subject.grid[1][2].alive = true
      expect(subject.grid[1][2]).to be_alive
      expect(subject.living_neighbours_of(subject.grid[1][1]).count).to eq(1)
    end

    it 'should detect a neighbour to the SouthWest' do
      expect(subject.grid[2][0]).to be_dead
      subject.grid[2][0].alive = true
      expect(subject.grid[2][0]).to be_alive
      expect(subject.living_neighbours_of(subject.grid[1][1]).count).to eq(1)
    end

    it 'should detect a neighbour to the South' do
      expect(subject.grid[2][1]).to be_dead
      subject.grid[2][1].alive = true
      expect(subject.grid[2][1]).to be_alive
      expect(subject.living_neighbours_of(subject.grid[1][1]).count).to eq(1)
    end

    it 'should detect a neighbour to the SouthEast' do
      expect(subject.grid[2][2]).to be_dead
      subject.grid[2][2].alive = true
      expect(subject.grid[2][2]).to be_alive
      expect(subject.living_neighbours_of(subject.grid[1][1]).count).to eq(1)
    end
  end

  context 'Game' do
    subject { Game.new }

    it 'should create a new Game object' do
      expect(subject.is_a?(Game)).to be_truthy
    end

    it 'should respond to proper methods' do
      expect(subject.respond_to?(:world)).to be_truthy
      expect(subject.respond_to?(:seeds)).to be_truthy
    end

    it 'should be initialized properly' do
      expect(subject.world.is_a?(World)).to be_truthy
      expect(subject.seeds.is_a?(Array)).to be_truthy
    end

    it 'should plant seeds properly' do
      game = Game.new(world, seeds=[[1, 2], [0, 2]])
      expect(game.world.grid[1][2]).to be_alive
      expect(game.world.grid[0][2]).to be_alive
    end
  end

  context 'Rules' do
    context 'Rule 1: any live cell with fewer than two live neighbours dies, as if caused by underpopulation' do
      it 'should kill a living cell without living neighbours' do
        game = Game.new(World.new, [[1,1]])
        expect(game.world.grid[1][1]).to be_alive
        game.tick!
        expect(game.world.grid[1][1]).to be_dead
      end

      it 'should kill a living cell with only 1 living neighbour' do
        game = Game.new(World.new, [[1,0], [2,0]])
        game.tick!
        expect(game.world.grid[1][0]).to be_dead
        expect(game.world.grid[2][0]).to be_dead
      end

      it 'should not kill a living cell with 2 living neighbours' do
        game = Game.new(World.new, [[0,1], [1,1], [2,1]])
        expect(game.world.grid[1][1]).to be_alive
        game.tick!
        expect(game.world.grid[1][1]).to be_alive
      end
    end

    context 'Rule 2: any live cell with two or three live neighbours lives on to the next generation' do
      it 'should keep alive a cell with 2 living neighbours' do
        game = Game.new(World.new, [[0,0], [0,1], [0,2]])
        expect(game.world.grid[0][1]).to be_alive
        game.tick!
        expect(game.world.grid[0][1]).to be_alive
      end

      it 'should keep alive a cell with 3 living neighbours' do
        game = Game.new(World.new, [[0,0], [0,1], [1,0], [1,2]])
        expect(game.world.grid[0][0]).to be_alive
        game.tick!
        expect(game.world.grid[0][0]).to be_alive
      end

      it 'should bring to life a cell with 2 living neighbours' do
        game = Game.new(World.new, [[0,1], [1,0]])
        expect(game.world.grid[0][0]).to be_dead
        game.tick!
        expect(game.world.grid[0][0]).to be_alive
      end

      it 'should bring to life a cell with 3 living neighbours' do
        game = Game.new(World.new, [[0,1], [1,0], [1,2]])
        expect(game.world.grid[0][0]).to be_dead
        game.tick!
        expect(game.world.grid[0][0]).to be_alive
      end
    end

    context 'Rule 3: any live cell with more than three live neighbours dies, as if by overpopulation' do
      it 'should kill a living cell with more than 3 living neighbours' do
        game = Game.new(World.new, [[0,1], [1,0], [1,1], [1,2], [2,1]])
        expect(game.world.grid[1][1]).to be_alive
        game.tick!
        expect(game.world.grid[1][1]).to be_dead
      end
    end

    context 'Rule 4: any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction' do
      it 'should bring to life a cell with 3 living neighbours' do
        game = Game.new(World.new, [[0,1], [1,0], [1,2]])
        expect(game.world.grid[0][0]).to be_dead
        game.tick!
        expect(game.world.grid[0][0]).to be_alive
      end
    end
  end
end
