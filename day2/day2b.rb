# Part 2
total = File.open("input.txt").map do |line|

  hands = line.split(":").last.split(";")
  totals = Hash.new(0)

  hands.each do |hand|
    red = hand.match(/(\d+) red/)
    blue = hand.match(/(\d+) blue/)
    green = hand.match(/(\d+) green/)

    totals[:red] = red[1].to_i if red && red[1].to_i > totals[:red]
    totals[:blue] = blue[1].to_i if blue && blue[1].to_i > totals[:blue]
    totals[:green] = green[1].to_i if green && green[1].to_i > totals[:green]
  end
  totals.values.inject(:*)
end.sum
puts total
