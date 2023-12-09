class Node
  attr_accessor :name, :left, :right
  def initialize(name)
    self.name = name
  end
end

class NodeMap
  def initialize
    @nodes = []
  end

  def add(node)
    @nodes << node
  end

  def find_by_name(name_name)
    @nodes.select { |node| node.name == name_name }.first
  end
end

file = File.readlines("input.txt").map(&:chomp)
route = file[0].split("")
nodes = NodeMap.new
node_associations = {}

file[2..-1].each do |line|
  parts = line.split(" = ")
  node_name = parts[0]
  children = parts[1].chars.reject { |c| c == "(" || c == ")" || c == " "}.join.split(",")
  nodes.add(Node.new(node_name))
  node_associations[node_name] = children
end

node_associations.each do |node_name, children|
  nodes.find_by_name(node_name).left = nodes.find_by_name(children[0])
  nodes.find_by_name(node_name).right = nodes.find_by_name(children[1])
end

start_node = nodes.find_by_name "AAA"
end_node = nodes.find_by_name "ZZZ"

current_node = start_node

count = 0
found = false
while !found

  route.each do |step|
    pp "On #{current_node.name}"
    if step == "L"
      current_node = current_node.left
    else
      current_node = current_node.right
    end
    count += 1
    found = current_node == end_node
  end

end

puts count