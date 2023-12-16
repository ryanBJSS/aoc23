def find_reflection(pairs_row, rows, modifier)
  pairs_row.map do |pair|
    first_index = pair[0]
    second_index = pair[1]
    search = true
    found = false
    smudge = nil
    while search do
      row1 = rows.find { |rr| rr[:index] == first_index }
      row2 = rows.find { |rr| rr[:index] == second_index }
      if row1.nil? || row2.nil?
        found = true if smudge
        search = false
      elsif row1[:chars].map.with_index { |c, i| c != row2[:chars][i] }.select { |v| v }.size == 0
        first_index -= 1
        second_index += 1
      elsif row1[:chars].map.with_index { |c, i| c != row2[:chars][i] }.select { |v| v }.size == 1 && !smudge
        first_index -= 1
        second_index += 1
        smudge = true
      else
        search = false
      end
    end
    if found && smudge
      pair[0].to_i * modifier
    end
  end
end

all_rows = File.read("input.txt").split("\n\n").map do |grid|
  grid.split("\n").map{ |row| row.split("") }
end

totals = all_rows.flat_map do |rows|
  cols = rows.transpose

  rows = rows.map.with_index do | row, i|
    { index: i + 1, chars: row }
  end

  cols = cols.map.with_index do | col, i|
    { index: i + 1, chars: col }
  end

  pairs_row = []
  rows.each_cons(2) { |a,b| pairs_row << [a[:index], b[:index]] }
  pairs_col = []
  cols.each_cons(2) { |a,b| pairs_col << [a[:index], b[:index]] }

  find_reflection(pairs_row, rows, 100) + find_reflection(pairs_col, cols, 1)
end

pp totals.compact.sum