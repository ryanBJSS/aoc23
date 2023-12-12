
lines = []
File.open("input.txt").each do |line|
  springs, counts = line.split(" ")
  springs = springs
  counts = counts.split(",").map(&:to_i)
  lines << { springs: springs, counts: counts}
end

def day12(line, counts)
  pp line
  thing(line, counts,-1)
end

def thing(line, counts, depth)
  depth += 1
  padding = " " * (depth * 2)
  pp "#{padding}Line is #{line}"
  target_count = counts.first
  pp "#{padding}Target count is #{target_count}"
  if (line == nil || line.empty? && target_count.nil?) || (target_count.nil? && !line.chars.include?("#"))
    pp "#{padding}Success #{line} #{counts}"
    return 1
  elsif target_count.nil? || line.empty?
    pp "#{padding}Fail: Run out of stuff"
    return 0
  end

  if line[0] == "."
    pp "#{padding}Skipping '.'"
    return thing(line[1..-1], counts, depth)
  elsif line[0] == "?"
    pp "#{padding}Assuming . for #{line}"
    a = thing(line[1..-1], counts, depth)
    pp "#{padding}Assuming # for #{line}"
    b = thing("#"+line[1..-1], counts, depth)
    return a + b
  elsif line.size < target_count
    pp "#{padding}Fail: Line not big enough"
    return 0
  else
    check_segment = line[0..(target_count-1)]
    if check_segment.chars.include?(".")
      pp "#{padding}Segment: #{check_segment}"
      pp "#{padding}target count is: #{target_count}"
      pp "#{padding}Fail: Cant do contiguous size"
      return 0
    elsif line[target_count] == "#"
      pp "#{padding}Fail: Next line breaks it"
      return 0
    else
      pp "#{padding}my line is #{line}, the target count is #{target_count}, therefore #{line[target_count..-1]}"
      pp "#{padding}Legit, match for #{target_count}"
      return thing(line[(1+target_count)..-1], counts[1..-1], depth)
    end
  end


end

pp lines
pp lines.map { |l| day12(l[:springs], l[:counts]) }
