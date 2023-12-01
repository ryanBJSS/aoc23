# Part 1
puts File.open("input.txt").map { |line| "#{line.scan(/\d/).first}#{line.scan(/\d/).last}".to_i }.sum

# Part 2
def sub_words_for_numbers(line)
  line.sub(/\D+/, "one" => "1", "two" => "2", "three" => "3", "four" => "4", "five" => "5", "six" => "6", "seven" => "7", "eight" => "8", "nine"=> "9")
end

puts(File.open("input.txt").map do |line|
  first = sub_words_for_numbers(line.scan(/\d|one|two|three|four|five|six|seven|eight|nine/).first)
  last = sub_words_for_numbers(line.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).flatten.last)
  "#{first}#{last}".to_i
end.sum)