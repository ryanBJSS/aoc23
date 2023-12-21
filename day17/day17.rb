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
  PathItem.new(grid.start_node, :left, 1).id => 0,
  PathItem.new(grid.start_node,  :up, 1).id => 0
}

@ways_there = []
path = [PathItem.new(grid.start_node, :left, 1)]
p2 = [PathItem.new(grid.start_node, :up, 1)]
queue = FastContainers::PriorityQueue.new(:min)
queue.push(path, 0)
queue.push(p2,0)
while !queue.empty?

  path = queue.pop
  last_node = path.last.node

  grid.mappings[last_node.id].each do |(child, direction)|

    if path.last.direction == :up && direction == :down
      next
    end

    if path.last.direction == :down && direction == :up
      next
    end

    if path.last.direction == :left && direction == :right
      next
    end

    if path.last.direction == :right && direction == :left
      next
    end

    # Count last 3 steps with this node
    last3_directions = path.last(3).map(&:direction)

    # Work out consecutive steps to get here
    cons_steps_to_this_node = 1
    last3_directions.reverse.each do |dir|
      if dir == direction
        cons_steps_to_this_node += 1
      else
        break
      end
    end

    # Don't queue if too many steps
    next if cons_steps_to_this_node > 3


    # Attempt extending the path with this node
    new_path = Marshal.load(Marshal.dump(path))
    new_path << PathItem.new(child, direction, cons_steps_to_this_node)

    # Add this as a legit way to get there
    if child.id == grid.end_node.id
      @ways_there << new_path
    end

    # Do not queue if you have already got here cheaper
    cost_up_to_now = new_path.map(&:node).map(&:cost).sum - new_path.first.node.cost
    next if @visited[[child.i, child.j, direction,cons_steps_to_this_node]] && @visited[[child.i, child.j, direction, cons_steps_to_this_node]] < cost_up_to_now

    # Queue new path
    queue.push(new_path,cost_up_to_now)

    # Save cost to get here
    @visited[[child.i, child.j, direction, cons_steps_to_this_node]] = cost_up_to_now
  end


end

pp @ways_there.sort_by { |way| way.map(&:node).map(&:cost).sum }.first.map(&:direction)
pp @ways_there.sort_by { |way| way.map(&:node).map(&:cost).sum }.first
pp "Smallest: #{@ways_there.map { |way| way.map(&:node).map(&:cost).sum }.min}"
pp "Of #{@ways_there.size} paths"

