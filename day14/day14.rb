class Rock
  attr_accessor :type, :x, :y

  def initialize(type, x, y)
    self.type = type
    self.x = x
    self.y = y
  end

  def solid?
    type != "."
  end

  def swap_y_with(rock_to_swap)
    my_new_y = rock_to_swap.y
    swap_rock_new_y = self.y
    rock_to_swap.y = swap_rock_new_y
    self.y = my_new_y
  end
end

class Dish
  attr_accessor :rocks

  def initialize()
    self.rocks = []
  end

  def add(rock)
    self.rocks << rock
  end

  def rock_north_of(rock)
    rocks.find { |rock_to_find| rock_to_find.y == rock.y + 1 && rock_to_find.x == rock.x }
  end

  def movable_rocks
    rocks.sort_by { |rock| [-rock.y, rock.x] }.select { |rock| rock.type == "O" }
  end

  def tilt_north
    movable_rocks.each do |rock|
      north = rock_north_of rock
      while !north.nil? && !north.solid?
        rock.swap_y_with(north)
        north = rock_north_of rock
      end
    end
  end

  def display
    row_size = Math.sqrt(rocks.size)
    (1..row_size).reverse_each do |y|
      (1..row_size).each do |x|
        print(rocks.find { |rock| rock.x == x && rock.y == y }&.type)
      end
      puts
    end
  end

  def total_load
    movable_rocks.map(&:y).sum
  end

end

dish = Dish.new
File.readlines("input.txt").reverse.map(&:chomp).each_with_index do |row, i|
  row.chars.each_with_index do |col, j|
    dish.add Rock.new(col, j+1, i+1)
  end
end

dish.display
dish.tilt_north
puts
dish.display
puts dish.total_load
