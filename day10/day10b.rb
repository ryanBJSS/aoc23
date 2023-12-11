class NodeMap
  def initialize
    @nodes = []
  end

  def add(node)
    @nodes << node
  end

  def start_node
    @nodes.find { |node| node.symbol == "S" }
  end

  def find_top_of(node_to_find)
    @nodes.find { |node| node.i == node_to_find.i - 1 && node.j == node_to_find.j }
  end

  def find_bottom_of(node_to_find)
    @nodes.find { |node| node.i == node_to_find.i + 1 && node.j == node_to_find.j }
  end

  def find_left_of(node_to_find)
    @nodes.find { |node| node.i == node_to_find.i && node.j == node_to_find.j - 1 }
  end

  def find_right_of(node_to_find)
    @nodes.find { |node| node.i == node_to_find.i && node.j == node_to_find.j + 1 }
  end

  def max_node
    @nodes.find { |node| node.i == @nodes.map(&:i).max && node.j == @nodes.map(&:j).max }
  end

  def find(i, j)
    @nodes.find { |node| node.i == i && node.j == j }
  end

  def nodes
    @nodes
  end
end

class Node
  attr_accessor :i, :j
  def initialize(symbol, i, j)
    @symbol = symbol
    @children = []
    @i = i
    @j = j
  end

  def add_children(node)
    @children << node
  end

  def symbol
    @symbol
  end

  def left_child
    @children[0]
  end

  def right_child
    @children[1]
  end
end


node_map = NodeMap.new

File.open("input.txt").map(&:chomp).each_with_index do |line, i|
  line.chars.each_with_index do |row, j|
    node_map.add Node.new(row, i, j)
  end
end


left_of_start = node_map.find_left_of node_map.start_node
right_of_start = node_map.find_right_of node_map.start_node
top_of_start = node_map.find_top_of node_map.start_node
bottom_of_start = node_map.find_bottom_of node_map.start_node

connections_to_start = []

if top_of_start && (top_of_start.symbol == "|" || top_of_start.symbol == "7" || top_of_start.symbol == "F")
  connections_to_start << top_of_start
end

if bottom_of_start && (bottom_of_start.symbol == "|" || bottom_of_start.symbol == "L" || bottom_of_start.symbol == "J")
  connections_to_start << bottom_of_start
end

if left_of_start && (left_of_start.symbol == "L" || left_of_start.symbol == "F" || left_of_start.symbol == "-")
  connections_to_start << left_of_start
end

if right_of_start && (right_of_start.symbol == "J" || right_of_start.symbol == "7" || right_of_start.symbol == "-")
  connections_to_start << right_of_start
end

connections_to_start.each { |connection| node_map.start_node.add_children connection }

node_map.nodes.each do |node|
  if node.symbol == "|"
    node.add_children(node_map.find_top_of(node))
    node.add_children(node_map.find_bottom_of(node))
  elsif node.symbol == "-"
    node.add_children(node_map.find_left_of(node))
    node.add_children(node_map.find_right_of(node))
  elsif node.symbol == "L"
    node.add_children(node_map.find_top_of(node))
    node.add_children(node_map.find_right_of(node))
  elsif node.symbol == "J"
    node.add_children(node_map.find_left_of(node))
    node.add_children(node_map.find_top_of(node))
  elsif node.symbol == "7"
    node.add_children(node_map.find_bottom_of(node))
    node.add_children(node_map.find_left_of(node))
  elsif node.symbol == "F"
    node.add_children(node_map.find_right_of(node))
    node.add_children(node_map.find_bottom_of(node))
  end
end


start_node = node_map.start_node
current_node = node_map.start_node
previous_node = nil
steps = 0
nodes_on_path = []
loop do
  nodes_on_path << current_node
  # puts "On node #{current_node.symbol}"
  next_node = current_node.right_child
  if next_node != previous_node
    previous_node = current_node
    current_node = next_node
    steps += 1
  else
    previous_node = current_node
    current_node = current_node.left_child
    steps += 1
  end
  if current_node == start_node
    pp steps / 2.0
    break
  end
end


max_node = node_map.max_node
inside_nodes = []

max_node.i.times do |row|
  outside = true
  max_node.j.times do |col|
    current_node = node_map.find(row, col)
    if nodes_on_path.include?(current_node) && ["|", "7", "F"].include?(current_node.symbol)
      outside = !outside
    end
    inside_nodes << current_node unless outside || nodes_on_path.include?(current_node)
  end
end

# pp inside_nodes.map(&:symbol)
# pp nodes_on_path.map(&:symbol)
# pp node_map.find(5,5).symbol
pp inside_nodes.count