require 'fc'
class PathItem
  attr_accessor :node, :direction

  def initialize(node, direction)
    self.node = node
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
    @nodes = Hash.new { |hash, key| hash[key] = {} }
    @mappings = {  }
  end

  def mappings
    @mappings
  end

  def start_node
    @nodes[0][0]
  end

  def end_node
    max = @nodes.keys.max - 1
    @nodes[max][max]
  end

  def add(node)
    @nodes[node.i][node.j] = node
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
pp "A"
grid.nodes.each do |i,jhash|
  jhash.each do |j, node|
    nodes_to_add = []
    nodes_to_add << [grid.nodes.dig(i,j - 1), :left] if grid.nodes.dig(i,j - 1)
    nodes_to_add << [grid.nodes.dig(i,j + 1), :right] if grid.nodes.dig(i,j + 1)
    if grid.nodes.has_key?(i - 1) && grid.nodes.has_key?(j)
      nodes_to_add << [grid.nodes[i - 1][j], :up]
    end
    if grid.nodes.has_key?(i + 1) && grid.nodes.has_key?(j)
      nodes_to_add << [grid.nodes[i + 1][j], :down]
    end
    grid.mappings[node.id] = nodes_to_add
  end


end
pp "B"
@visited = {
  PathItem.new(grid.start_node, :left).id => 0,
  PathItem.new(grid.start_node,  :up).id => 0
}

@ways_there = []
path = [PathItem.new(grid.start_node, :left)]
p2 = [PathItem.new(grid.start_node, :up)]
queue = FastContainers::PriorityQueue.new(:min)
queue.push(path, 0)
queue.push(p2,0)
while !queue.empty?
  path = queue.pop
  last_node = path.last.node
  grid.mappings[last_node.id].each do |(child, direction)|
    next if child.id == path[-2]&.id # No back
    if child.id == grid.end_node.id
      @ways_there << (path + [PathItem.new(child,direction)])
    end
    cost_up_to_now = path.map(&:node).map(&:cost).sum + child.cost
    # next if @visited[[child.i, child.j, direction]] && @visited[[child.i, child.j, direction]] < cost_up_to_now
    if @visited[[child.i, child.j, direction]].nil? || @visited[[child.i, child.j, direction]] > cost_up_to_now
      must_change_direction = path.last(3).all? { |p| p.direction == direction }
      next if must_change_direction
      new_path = Marshal.load(Marshal.dump(path))
      new_path << PathItem.new(child, direction)
      queue.push(new_path,cost_up_to_now)
      @visited[[child.i, child.j, direction]] = cost_up_to_now
    # end
  end
end

pp @ways_there.map { |way| way.map(&:node).map(&:cost).sum }.sort.min
