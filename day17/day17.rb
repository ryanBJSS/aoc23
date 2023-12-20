class PathItem
  attr_accessor :node, :heat_lost_getting_there, :direction

  def initialize(node, heat_lost_getting_there, direction)
    self.node = node
    self.heat_lost_getting_there = heat_lost_getting_there
    self.direction = direction
  end

  def id
    [node.i, node.j, direction]
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
  PathItem.new(grid.start_node, 0, :up),
]

@ways_there = {}
path = [PathItem.new(grid.start_node, 0, :left)]
p2 = [PathItem.new(grid.start_node, 0, :up)]
queue = [path, p2]

while !queue.empty?
  path = queue.shift
  last_node = path.last.node



  grid.mappings[last_node.id].each do |(child, direction)|
    if child.id == grid.end_node.id
      @ways_there << (path + [PathItem.new(child,path.map(&:node).map(&:cost).sum,direction)])
    end
    if @visited.find { |path_item| path_item.id == [child.i, child.j, direction] }.nil?# || @visited.find { |path_item| path_item.id == [child.i, child.j, direction] }.heat_lost_getting_there > (path.map(&:heat_lost_getting_there).last + child.cost)

      next if child.id == path[-2]&.id # No back
      must_change_direction = path.last(3).all? { |p| p.direction == direction }
      next if must_change_direction
      @visited << PathItem.new(child,path.map(&:node).map(&:cost).sum,direction)
      new_path = Marshal.load(Marshal.dump(path))
      new_path << PathItem.new(child,path.map(&:node).map(&:cost).sum,direction)
      queue << new_path

    end
  end
end

pp @ways_there.map { |way| way.map(&:node).map(&:cost).sum }.sort
