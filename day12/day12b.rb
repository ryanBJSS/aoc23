lines = File.open("input.txt").map do |line|
  springs, counts = line.split(" ")
  springs = springs
  counts = counts.split(",").map(&:to_i)
  { springs: Array.new(5, springs).join('?'), counts: counts * 5 }
end

def day12(line, counts)
  @cache ||= Hash.new { |hash, key| hash[key] = {} }
  @cache[line][counts] ||=begin

    if line.nil? && counts.empty? || counts.empty? && !line.chars.include?("#")
      return 1
    elsif counts.empty? || line.nil?
      return 0
    end

    target_count = counts.first
    if line[0] == "."
      day12(line[1..-1], counts)
    elsif line[0] == "?"
      day12(line[1..-1], counts) + day12("#" + line[1..-1], counts)
    elsif line.size < target_count || line[0..(target_count-1)].chars.include?(".") || line[target_count] == "#"
      0
    else
      day12(line[(1+target_count)..-1], counts[1..-1])
    end
  end
end

pp lines.map { |l| day12(l[:springs], l[:counts]) }.sum
