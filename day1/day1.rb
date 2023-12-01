# Part 1
puts File.open("input.txt").map { |line| "#{line.scan(/\d/).first}#{line.scan(/\d/).last}".to_i }.sum

# Part 2
def subWordsForNumbers(line) 
  line =  line.sub("one", "1")
  line =  line.sub("two", "2")
  line =  line.sub("three", "3")
  line =  line.sub("four", "4")
  line =  line.sub("five", "5")
  line =  line.sub("six", "6")
  line =  line.sub("seven", "7")
  line =  line.sub("eight", "8")
  line =  line.sub("nine", "9")
end

puts(File.open("input.txt").map do |line|
  first = subWordsForNumbers(line.scan(/\d|one|two|three|four|five|six|seven|eight|nine/).first)
  last = subWordsForNumbers(line.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).flatten.last)
  "#{first}#{last}".to_i
end.sum)