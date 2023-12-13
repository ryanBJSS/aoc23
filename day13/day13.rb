
all_rows = []
row = []
File.open("input.txt").map do |line|

  if line == "\n"
    all_rows << row
    row = []
  else
    row << line.chomp.chars
  end
end
all_rows << row
totals = []
all_rows.each do |rows|

cols = rows.transpose

rows = rows.map.with_index do | row, i|
  { index: i + 1, chars: row }
end

cols = cols.map.with_index do | row, i|
  { index: i + 1, chars: row }
end

pairs_row = []
rows.each_cons(2) { |a,b| pairs_row << [a[:index], b[:index]] if a[:chars] == b[:chars] }
pairs_col = []
cols.each_cons(2) { |a,b| pairs_col << [a[:index], b[:index]] if a[:chars] == b[:chars] }


r = pairs_row.map do |pair|
  first_index = pair[0]
  second_index = pair[1]
  search = true
  found = false
  while search do
    row1 = rows.find { |rr| rr[:index] == first_index }
    row2 = rows.find { |rr| rr[:index] == second_index }
    if row1.nil? || row2.nil?
      found = true
      search = false
    elsif row1[:chars] == row2[:chars]
      first_index -= 1
      second_index += 1
    else
      search = false
    end
  end
  if found
    pair[0].to_i * 100
  end
end

totals << r
r = pairs_col.map do |pair|
  first_index = pair[0]
  second_index = pair[1]
  search = true
  found = false
  while search do
    col1 = cols.find { |rr| rr[:index] == first_index }
    col2 = cols.find { |rr| rr[:index] == second_index }
    if col1.nil? || col2.nil?
      found = true
      search = false
    elsif col1[:chars] == col2[:chars]
      first_index -= 1
      second_index += 1
    else
      search = false
    end
  end
  if found
    pair[0].to_i
  end
end
totals << r
end
pp totals
pp totals.flatten.compact.sum