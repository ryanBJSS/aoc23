class NodeMap
  def initialize
    @nodes = []
  end

  def add(node)
    @nodes << node
  end

  def nodes
    @nodes
  end

  def get_with_i(i)
    @nodes.select { |node| node.i == i }
  end

  def get_with_j(j)
    @nodes.select { |node| node.j == j }
  end


end

class Node
  attr_accessor :i, :j
  def initialize(i, j)
    @i = i
    @j = j
  end

  def expand_in_i(n)
    @i += n
  end

  def expand_in_j(n)
    @j += n
  end
end


node_map = NodeMap.new

empty_rows = []
empty_cols = []
row_lenth = nil
File.open("input.txt").map(&:chomp).each_with_index do |line, i|
  row_lenth = line.size
  empty_rows << i if line.chars.reject { |c| c == "." }.size == 0
  line.chars.each_with_index do |row, j|
    node_map.add Node.new(i, j) if row != "."
  end
end

row_lenth.times do |j|
  empty_cols << j if node_map.get_with_j(j).empty?
end

PART_2 = 999999
empty_rows = empty_rows.map.with_index { |v, i| v + ((PART_2 * i)) }
empty_cols = empty_cols.map.with_index { |v, i| v + ((PART_2 * i)) }

empty_rows.each do |row|
  node_map.nodes.select { |node| node.i > row }.map { |node| node.expand_in_i(PART_2) }
end

empty_cols.each do |col|
  node_map.nodes.select { |node| node.j > col }.map { |node| node.expand_in_j(PART_2) }
end

pp(node_map.nodes.combination(2).map do |node1, node2|
  ((node1.i) - node2.i).abs + (node1.j - node2.j).abs
end.sum)

