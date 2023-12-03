# Part 2
schematic = []
File.open("input.txt").each do |line|
  schematic << line.chomp.chars
end

gears = []
numbers = []
total = []
schematic.each_with_index do |row, i|
  row.each_with_index do |col,j|
    if schematic[i][j].match(/\*/)
      gears << [i,j]
    end
  end
end

schematic.each_with_index do |row_arr, i|
  row = row_arr.join
  moo = row.scan(/\d+/)
  indexes =  row.enum_for(:scan,/\d+/).map { Regexp.last_match.begin(0) }
  moo.each_with_index do |number, lindex|
    index = indexes[lindex]
    numbers << { digit: number, coord: [i, index ]}
  end
end

gears.each do |gear|
  i = gear[0]
  j = gear[1]

  up = [i-1,j]
  down = [i+1,j]
  right = [i,j+1]
  left = [i,j-1]
  bl = [i+1,j-1]
  br = [i+1,j+1]
  tl = [i-1,j-1]
  tr = [i-1,j+1]
  numbers_matched = []
  [left, right, up, down, tl, tr, bl, br].each do |match|
    mm = numbers.select do |num|
      range = (num[:coord][1]..(num[:coord][1]+num[:digit].size-1)).to_a
      matched_num = num[:coord][0] == match[0] && range.include?(match[1])
      matched_num
    end.first
    numbers_matched << mm
  end

  if numbers_matched.uniq.compact.size == 2
    ratio = numbers_matched.uniq.compact.map { |h| h[:digit].to_i }.inject(&:*)
    total << { gear: gear, ratio: ratio, numbers: numbers_matched.uniq.compact.map { |h| h[:digit] } }
  end

end

# [0,0] [0,2]  [0,1]
# puts numbers
pp gears
puts total
puts total.map { |t| t[:ratio]}.sum

# 78024880