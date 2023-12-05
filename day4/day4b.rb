cards = {}
File.open("input.txt").each do |line|
  card_number = line.split(":").first.split(" ").last.to_i
  winning_numbers = line.split(":").last.split("|").first.strip.split(" ").map(&:to_i)
  my_numbers = line.split(":").last.split("|").last.strip.split(" ").map(&:to_i)

  overlap_size = (winning_numbers & my_numbers).size
  cards[card_number] = { winning_numbers: winning_numbers, my_numbers: my_numbers, count: 1, overlap_size: overlap_size}
end

cards.each do |k, v|
  v[:count].times do
    v[:overlap_size].times do |i|
      index = i + 1
      cards[k + index][:count] += 1
    end
  end
end

pp(cards.map do |k,v|
  v[:count]
end.sum)