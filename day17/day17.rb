require 'fc'
class PathItem
  attr_accessor :node, :direction, :steps_in_one_dir_to_get_here

  def initialize(node, direction, steps_in_one_dir_to_get_here)
    self.node = node
    self.direction = direction
    self.steps_in_one_dir_to_get_here = steps_in_one_dir_to_get_here
  end

  def id
    [node.i, node.j, direction, steps_in_one_dir_to_get_here]
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
  PathItem.new(grid.start_node, :left, 0).id => 0,
  PathItem.new(grid.start_node,  :up, 0).id => 0
}

@ways_there = []
path = [PathItem.new(grid.start_node, :left, 0)]
p2 = [PathItem.new(grid.start_node, :up, 0)]
queue = FastContainers::PriorityQueue.new(:min)
queue.push(path, 0)
queue.push(p2,0)
while !queue.empty?
  path = queue.pop
  last_node = path.last.node
  grid.mappings[last_node.id].each do |(child, direction)|
    next if child.id == path[-2]&.id # No back
    steps_in_one_dir_to_get_here = path.last(3).map(&:direction).select { |d| d == direction }.size
    if child.id == grid.end_node.id
      @ways_there << (path + [PathItem.new(child,direction, steps_in_one_dir_to_get_here)])
      puts "moo"
    end
    cost_up_to_now = path.map(&:node).map(&:cost).sum + child.cost
    next if steps_in_one_dir_to_get_here == 3
    next if @visited[[child.i, child.j, direction,steps_in_one_dir_to_get_here]] && @visited[[child.i, child.j, direction, steps_in_one_dir_to_get_here]] < cost_up_to_now
      must_change_direction = path.last(3).all? { |p| p.direction == direction }
      next if must_change_direction
      new_path = Marshal.load(Marshal.dump(path))
      new_path << PathItem.new(child, direction, steps_in_one_dir_to_get_here)
      queue.push(new_path,cost_up_to_now)
      @visited[[child.i, child.j, direction, steps_in_one_dir_to_get_here]] = cost_up_to_now
    # end
  end
end

pp @ways_there.map { |way| way.map(&:node).map(&:cost).sum }.min
pp @ways_there.map { |path| path.direction }