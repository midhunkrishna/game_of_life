require 'yaml'
require_relative './being'

class World
  LIVE_SEED = "1"
  attr_accessor :ecosystem, :future_ecosystem

  def initialize(seeds)
    @ecosystem = populate_ecosystem(seeds)
  end

  def evolve
    loop do
      @future_ecosystem = deep_clone(ecosystem)
      each_cell_with_index do |row, column|
        alive_count = ecosystem[row][column].alive_neighbours(row, column)
        assign_beings(alive_count, row, column)
      end
      render
      @ecosystem = future_ecosystem
      sleep(0.4)
    end
  end

  def assign_beings(alive_count, row, column)
    @future_ecosystem[row][column] = Being.new(self, false, row, column) if alive_count < 2
    @future_ecosystem[row][column] = Being.new(self, true, row, column)  if alive_count == 3
    @future_ecosystem[row][column] = Being.new(self, false, row, column) if alive_count > 3
  end

  def alive_being(alive_count)
    alive_count == 3
  end

  def render
    system("clear")
    ecosystem.each do |row|
      puts row.join(",")
    end
  end

  def row_max
    ecosystem.first.size
  end

  def col_max
    ecosystem.size
  end

  def each_cell_with_index
    ecosystem.each_with_index do |row, row_index|
      row.each_with_index do |_, column_index|
        yield row_index, column_index
      end
    end
  end

  private

  def deep_clone(ecosystem)
    YAML.load(YAML.dump(ecosystem))
  end

  def populate_ecosystem(seeds)
    receptacle = seeds.dup
    seeds.each_with_index do |row, row_index|
      row.each_with_index  do |seed, column_index|
        receptacle[row_index][column_index] = Being.new(self, alive_seed?(seed), row_index, column_index)
      end
    end
    receptacle
  end

  def alive_seed?(seed)
    seed == LIVE_SEED
  end
end


# World.new.render
