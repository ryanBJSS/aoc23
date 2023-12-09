lines = File.open("input.txt").map { |l| l.split(" ").map(&:to_i) }
def calculate(lines)

  lines.map do |line|

    processed_lines = [line]

    while line.reject { |n| n == 0 }.size != 0
      next_line = line.each_cons(2).map { |a,b| b - a }
      processed_lines << next_line
      line = next_line
    end

    processed_lines = processed_lines.reverse
    processed_lines.each_with_index do |l, i|
      if i == 0
        processed_lines[i] << 0
      else
        processed_lines[i] << processed_lines[i-1][-1] + l[-1]
      end
    end
    processed_lines[-1][-1]
  end
end

pp calculate(lines).sum
pp calculate(lines.map(&:reverse)).sum