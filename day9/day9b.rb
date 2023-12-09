def process_line(line)
  line.each_cons(2).map do |a,b|
    b - a
  end
end

lines = File.open("input.txt").map { |l| l.split(" ") }

predictions = []

lines.each do |line|

  processed_lines = []
  line = line.map(&:to_i)

  processed_lines << line
  while line.reject { |n| n == 0 }.size != 0
    next_line = process_line(line)
    processed_lines << next_line
    line = next_line
  end

  processed_lines = processed_lines.reverse
  processed_lines.each_with_index do |line, i|
    if i == 0
      processed_lines[i] << 0
    else
      processed_lines[i].prepend(line[0] - processed_lines[i - 1][0])
    end
  end
  processed_lines
  predictions << processed_lines[-1][0]

end

pp predictions.sum