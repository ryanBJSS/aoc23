time, distance = File.readlines("input.txt").map { |l| l.split(":").last.delete(' ').to_i }
puts (0..time).map { |t| (time - t) * t > distance ? 1 : 0 }.sum


