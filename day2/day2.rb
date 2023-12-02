# Part 1
total = File.open("input.txt").map do |line|
  game_id = line.split(":").first.split(" ").last.to_i
  hands = line.split(":").last.split(";")

  hands.any? do |hand|
    red = hand.match(/(\d+) red/)
    blue = hand.match(/(\d+) blue/)
    green = hand.match(/(\d+) green/)
    red && red[1].to_i > 12 || blue && blue[1].to_i > 14 || green && green[1].to_i > 13
  end ? 0 : game_id

end.sum

puts total
