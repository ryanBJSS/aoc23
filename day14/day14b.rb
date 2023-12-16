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

  def swap_x_with(rock_to_swap)
    my_new_x = rock_to_swap.x
    swap_rock_new_x = self.x
    rock_to_swap.x = swap_rock_new_x
    self.x = my_new_x
  end
end

class Dish

  def initialize()
    @rocks = []
  end

  def add(rock)
    @rocks << rock
  end

  def rock_north_of(rock)
    @rocks.find { |rock_to_find| rock_to_find.y == rock.y + 1 && rock_to_find.x == rock.x }
  end

  def rock_south_of(rock)
    @rocks.find { |rock_to_find| rock_to_find.y == rock.y - 1 && rock_to_find.x == rock.x }
  end

  def rock_east_of(rock)
    @rocks.find { |rock_to_find| rock_to_find.x == rock.x + 1 && rock_to_find.y == rock.y }
  end

  def rock_west_of(rock)
    @rocks.find { |rock_to_find| rock_to_find.x == rock.x - 1 && rock_to_find.y == rock.y }
  end

  def movable_rocks
    @rocks.select { |rock| rock.type == "O" }
  end

  def state
    @rocks.sort_by { |rock| [-rock.y, rock.x] }.map { |rock| [rock.type, rock.x, rock.y] }
  end

  def state=(new_state)
    @rocks = new_state.map { |title, x, y|  Rock.new(title, x, y) }
  end

  def tilt_north
    movable_rocks.sort_by { |rock| [-rock.y, rock.x] }.each do |rock|
      north = rock_north_of rock
      while !north.nil? && !north.solid?
        rock.swap_y_with(north)
        north = rock_north_of rock
      end
    end
  end

  def tilt_south
    movable_rocks.sort_by { |rock| [rock.y, rock.x] }.each do |rock|
      south = rock_south_of rock
      while !south.nil? && !south.solid?
        rock.swap_y_with(south)
        south = rock_south_of rock
      end
    end
  end

  def tilt_east
    movable_rocks.sort_by { |rock| [rock.y, -rock.x] }.each do |rock|
      east = rock_east_of rock
      while !east.nil? && !east.solid?
        rock.swap_x_with(east)
        east = rock_east_of rock
      end
    end
  end

  def tilt_west
    movable_rocks.sort_by { |rock| [rock.y, rock.x] }.each do |rock|
      west = rock_west_of rock
      while !west.nil? && !west.solid?
        rock.swap_x_with(west)
        west = rock_west_of rock
      end
    end
  end

  def display
    row_size = Math.sqrt(@rocks.size)
    (1..row_size).reverse_each do |y|
      (1..row_size).each do |x|
        print(@rocks.find { |rock| rock.x == x && rock.y == y }&.type)
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


cache = []

first_appearance = nil
second_appearance = nil
1000000000.times do |i|
  dish.tilt_north
  dish.tilt_west
  dish.tilt_south
  dish.tilt_east

  if cache.index(dish.state)
    first_appearance = cache.index(dish.state)
    second_appearance = i
    break
  end
  cache <<  dish.state
end


cycle_length = second_appearance - first_appearance
dish.state = cache[first_appearance + (1000000000 - first_appearance) % cycle_length -1]
puts dish.total_load

