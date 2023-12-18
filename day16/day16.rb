class Grid
  attr_reader :nodes

  def initialize()
    @nodes = []
  end

  def add(node)
    nodes << node
  end

  def starting_node
    nodes.find { |node_to_find| node_to_find.i == 0 && node_to_find.j == 0 }
  end

  def top_row
    nodes.select { |node_to_find| node_to_find.i == 0 }
  end

  def bottom_row(row_size)
    nodes.select { |node_to_find| node_to_find.i == row_size - 1 }
  end

  def left_row
    nodes.select { |node_to_find| node_to_find.j == 0 }
  end

  def right_row(row_size)
    nodes.select { |node_to_find| node_to_find.j == row_size - 1}
  end

  def right_of(node)
    nodes.find { |node_to_find| node_to_find.i == node.i && node_to_find.j == node.j + 1 }
  end

  def left_of(node)
    nodes.find { |node_to_find| node_to_find.i == node.i && node_to_find.j == node.j - 1 }
  end

  def up_of(node)
    nodes.find { |node_to_find| node_to_find.i == node.i - 1 && node_to_find.j == node.j  }
  end

  def down_of(node)
    nodes.find { |node_to_find| node_to_find.i == node.i + 1 && node_to_find.j == node.j  }
  end

end

class Node
  attr_accessor :type, :i, :j

  def initialize(type, i, j)
    self.type = type
    self.i = i
    self.j = j
  end

  def mirror?
    type == "/" || type == "\\"
  end

  def to_s
    "#{i}, #{j}"
  end
end

class Laser
  @@lasers = []
  @@visited = []
  attr_accessor :direction

  def initialize(current_node, direction, grid)
    @current_node = current_node
    self.direction = direction
    @grid = grid
    @active = true
    @@lasers << self
  end

  def travel

    @active = !@@visited.include?([@current_node, direction])
    if @current_node.nil?  || !active?
      @active = false
      return
    end

    @@visited << [@current_node, direction]

    if @current_node.type == "|" && (direction == :right || direction == :left)
      Laser.new(@grid.up_of(@current_node), :up, @grid)
      Laser.new(@grid.down_of(@current_node), :down, @grid)
    elsif @current_node.type == "-" && (direction == :up || direction == :down)
      Laser.new(@grid.left_of(@current_node), :left, @grid)
      Laser.new(@grid.right_of(@current_node), :right, @grid)
    elsif @current_node.mirror?
      next_dir = next_direction(@current_node.type, direction)
      @current_node = @grid.send("#{next_dir}_of", @current_node)
      self.direction = next_dir
    else
      next_node = @grid.send("#{direction}_of", @current_node)
      @current_node = next_node
    end
  end

  def next_direction(type, direction)
    {
      "/"  => { left: :down, right: :up, up: :right, down: :left },
      "\\" => { left: :up, right: :down, up: :left, down: :right }
    }[type][direction]
  end

  def active?
    @active
  end

  def self.move_all
    while @@lasers.select(&:active?).any?
      @@lasers.select(&:active?).map(&:travel)
    end
    @@visited.uniq { |v| v[0] }.size
  end

  def self.reset!
    @@lasers = []
    @@visited = []
  end
end

grid = Grid.new
File.readlines("input.txt").map(&:chomp).each_with_index do |row, i|
  @row_size = row.size
  row.chars.each_with_index do |col, j|
    grid.add Node.new(col, i, j)
  end
end

totals = []

top = grid.top_row
bottom = grid.bottom_row(@row_size)
left = grid.left_row
right = grid.right_row(@row_size)

top.each do |starting_location|
  puts starting_location
  Laser.reset!
  Laser.new(starting_location, :down, grid)
  totals << Laser.move_all
  pp totals.last
end

bottom.each do |starting_location|
  puts starting_location
  Laser.reset!
  Laser.new(starting_location, :up, grid)
  totals << Laser.move_all
  pp totals.last
end

left.each do |starting_location|
  puts starting_location
  Laser.reset!
  Laser.new(starting_location, :right, grid)
  totals << Laser.move_all
  pp totals.last
end

right.each do |starting_location|
  puts starting_location
  Laser.reset!
  Laser.new(starting_location, :left, grid)
  totals << Laser.move_all
  pp totals.last
end

pp totals.max