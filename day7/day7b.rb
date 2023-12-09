def get_rank(raw_rank)
  { "A" => 14, "K" => 13, "Q" => 12, "J" => 1 , "T" => 10 }[raw_rank] || raw_rank.to_i
end

hands = File.open("input.txt").map do |line|
  cards_string, bid = line.split(" ")
  { cards: cards_string.split(""), bid: bid.to_i }
end

sorted_hands = hands.map do |hand|
  values = hand[:cards].map { |card| get_rank(card) }
  totals = values.each_with_object(Hash.new(0)) { |value, totals| totals[value] += 1 }.sort_by { |k,v| -v }.to_h

  wild = totals.delete(1)
  if totals.keys.first
    totals[totals.keys.first] += (wild || 0)
  else
    totals[0] = wild
  end

  { totals: totals, values: values, bid: hand[:bid] }
end.sort_by { |hash| [hash[:totals].values, hash[:values]]  }

pp sorted_hands
pp(sorted_hands.map.with_index do |hand, i|
  hand[:bid] * (i + 1)
end.sum)
