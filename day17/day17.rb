class PathItem
  attr_accessor :node, :step_count, :direction

  def initialize(node, step_count, direction)
    self.node = node
    self.step_count = step_count
    self.direction = direction
  end

  def id
    [node.i, node.j, step_count]
  end
end

class Node
  attr_accessor :i, :j, :cost
  def initialize(i, j, cost)
    self.i = i
    self.j = j
    self.cost = cost.to_i
  end

  def id
    [i,j]
  end

  def to_s
    "#{i},#{j}"
  end
end

class NodeMap
  def initialize
    @nodes = []
    @mappings = {}
  end

  def mappings
    @mappings
  end

  def start_node
    @nodes.find { |node_to_find| node_to_find.i == 0 && node_to_find.j == 0 }
  end

  def end_node
    max = @nodes.max { |n| n.i }.i - 1
    @nodes.find { |node_to_find| node_to_find.i == max && node_to_find.j == max }
  end

  def add(node)
    @nodes << node
  end

  def right_of(node)
    @nodes.find { |node_to_find| node_to_find.i == node.i && node_to_find.j == node.j + 1 }
  end

  def left_of(node)
    @nodes.find { |node_to_find| node_to_find.i == node.i && node_to_find.j == node.j - 1 }
  end

  def up_of(node)
    @nodes.find { |node_to_find| node_to_find.i == node.i - 1 && node_to_find.j == node.j  }
  end

  def down_of(node)
    @nodes.find { |node_to_find| node_to_find.i == node.i + 1 && node_to_find.j == node.j  }
  end

  def nodes
    @nodes
  end
end

grid = NodeMap.new

File.readlines("input.txt").map(&:chomp).each_with_index do |row, i|
  row.chars.each_with_index do |col, j|
    grid.add Node.new(i, j, col)
  end
end

grid.nodes.each do |node|
  nodes_to_add = []
  nodes_to_add << [grid.left_of(node), :left] if grid.left_of(node)
  nodes_to_add << [grid.right_of(node), :right] if grid.right_of(node)
  nodes_to_add << [grid.up_of(node), :up] if grid.up_of(node)
  nodes_to_add << [grid.down_of(node), :down] if grid.down_of(node)
  grid.mappings[node.id] = nodes_to_add
end



@visited = [
  PathItem.new(grid.start_node, 0, :left),
  PathItem.new(grid.start_node, 0, :right),
  PathItem.new(grid.start_node, 0, :up),
  PathItem.new(grid.start_node, 0, :down)
]
path = [grid.start_node]
queue = [Marshal.load(Marshal.dump(path))]

while !queue.empty?
  path = queue.shift
  last_node = path.last

  if last_node.id == grid.end_node.id
    puts "Win"
    exit
  end

    direction_count = 0
    direction_save = nil
  grid.mappings[last_node.id].each do |(child, direction)|
      # if direction_save == direction
      #   direction_count += 1
      # else
      #   direction_save = direction
      #   direction_count = 1
      # end
      # pp "Path"
      # pp path
      # pp "Child"
      # pp child
      # pp path.include?(child)
      # puts

      if !path.find { |path_item| path_item.id == child.id }
        new_path = Marshal.load(Marshal.dump(path))
        new_path << child
        queue << new_path
      end
  end
end

