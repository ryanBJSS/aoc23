
time_line, distance_line = File.readlines("input.txt")
distance_line = distance_line.split(":").last.strip.split(" ")
races = time_line.split(":").last.strip.split(" ").map.with_index do |time, i|
  { time: time.to_i, distance: distance_line[i].to_i }
end

total_wins = []
races.each do |race|
  wins = 0
  (0..race[:time]).each do |time|

    speed = time
    distance = (race[:time] - time) * speed
    wins += 1 if distance > race[:distance]
  end
  total_wins << wins
end

puts total_wins.inject(&:*)