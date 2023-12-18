class Node
  attr_accessor :i, :j, :cost, :children
  def initialize(i, j, cost)
    self.i = i
    self.j = j
    self.cost = cost.to_i
    @children = []
  end

  def add_child(node)
    @children << node
  end

  def to_s
    "#{i},#{j}"
  end
end

class NodeMap
  def initialize
    @nodes = []
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
  node.add_child [grid.left_of(node), :left]
  node.add_child [grid.right_of(node), :right]
  node.add_child [grid.up_of(node), :up]
  node.add_child [grid.down_of(node), :down]
end


path = [grid.start_node]
queue = [path]

while !queue.empty?
  path = queue.shift
  last = path.last

  if last == grid.end_node
    puts "Win"
    exit
  end

  unless last.nil?
    direction_count = 0
    direction_save = nil
    last.children.each do |(child, direction)|
      if direction_save == direction
        direction_count += 1
      else
        direction_save = direction
        direction_count = 1
      end
      if !path.include?(child) && direction_count < 4
        if child == grid.end_node
          min_cost = new_path.map { |p| p.cost }.sum
          pp min_cost
        end
        new_path = Marshal.load(Marshal.dump(path))
        new_path << child
        queue << new_path
      end
    end
  end
end

