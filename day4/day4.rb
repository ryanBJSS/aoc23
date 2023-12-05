total = []
File.open("input.txt").each do |line|
  card_number = line.split(":").first
  winning_numbers = line.split(":").last.split("|").first.strip.split(" ").map(&:to_i)
  my_numbers = line.split(":").last.split("|").last.strip.split(" ").map(&:to_i)

  overlap = winning_numbers & my_numbers
  total << overlap.inject(1) { |memo, i| memo * 2 } / 2
end


pp total.compact.sum