require 'fc'
require 'byebug'
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
    @mappings = {}
  end

  def mappings
    @mappings
  end

  def start_node
    @nodes[0][0]
  end

  def end_node
    max = @nodes.keys.max
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

pp "Preprocessing done"


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

    # Count last 3 steps with this node
    last4_directions = path.last(4).map(&:direction) + [direction]
    steps_in_one_dir_to_get_here = last4_directions.select { |d| d == direction }.size

    # Stop without queuing if that would be too many steps
    # debugger if last3_directions.include?(:right) && path.size > 2
    next if steps_in_one_dir_to_get_here > 3

    # Attempt extending the path with this node
    new_path = Marshal.load(Marshal.dump(path))
    new_path << PathItem.new(child, direction, steps_in_one_dir_to_get_here)

    next if child.id == path[-2]&.id # No back

    # Add this as a legit way to get there
    if child.id == grid.end_node.id
      @ways_there << new_path
    end

    # Do not queue if you have already got here cheaper
    cost_up_to_now = new_path.map(&:node).map(&:cost).sum - new_path.first.node.cost
    next if @visited[[child.i, child.j, direction,steps_in_one_dir_to_get_here]] && @visited[[child.i, child.j, direction, steps_in_one_dir_to_get_here]] < cost_up_to_now

    # Queue new path
    queue.push(new_path,cost_up_to_now)

    # Save cost to get here
    @visited[[child.i, child.j, direction, steps_in_one_dir_to_get_here]] = cost_up_to_now
  end


end

pp @ways_there.sort_by { |way| way.map(&:node).map(&:cost).sum }.first.map(&:direction)
pp "Smallest: #{@ways_there.map { |way| way.map(&:node).map(&:cost).sum }.min}"
pp "Of #{@ways_there.size} paths"

