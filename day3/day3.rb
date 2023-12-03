# Part 2
schematic = []
File.open("input.txt").each do |line|
  schematic << line.chomp.chars
end

totals = []
schematic.each_with_index do |row, i|
  number = []
  row.each_with_index do |col,j|

    if schematic[i][j].match(/\d+/)
      puts "MAtched #{schematic[i][j]}"
      number << {digit: schematic[i][j], coord: [i,j]}
      if j == (schematic[i].size - 1)
        puts "moo"
        number.each do |num|
          up = num[:coord][0]-1 >= 0 ? schematic.dig(num[:coord][0]-1,num[:coord][1]) : nil
          down = schematic.dig(num[:coord][0]+1,num[:coord][1])
          right = schematic.dig(num[:coord][0],num[:coord][1]+1)
          left = num[:coord][1]-1 >= 0 ? schematic.dig(num[:coord][0],num[:coord][1]-1) :  nil
          bl = num[:coord][1]-1 >= 0 ? schematic.dig(num[:coord][0]+1,num[:coord][1]-1) : nil
          br = schematic.dig(num[:coord][0]+1,num[:coord][1]+1)
          tl = num[:coord][1]-1 >= 0 && num[:coord][0]-1 >= 0 ? schematic.dig(num[:coord][0]-1,num[:coord][1]-1)  : nil
          tr = num[:coord][0]-1 >= 0 ? schematic.dig(num[:coord][0]-1,num[:coord][1]+1) : nil
          # puts [left, right, up, down, tl, tr, bl, br].inspect

          if [left, right, up, down, tl, tr, bl, br].any? { |check| check && check.match(/\D/) && check != "." }
            totals << number.map{ |n| n[:digit] }.join
            puts "Adding #{number.map{ |n| n[:digit] }.join}"
            break
          end
          end
      end
    elsif !number.empty?
      puts "nii"
      size = number.size
      count = 0
      number.each do |num|
        count += 1
        up = num[:coord][0]-1 >= 0 ? schematic.dig(num[:coord][0]-1,num[:coord][1]) : nil
        down = schematic.dig(num[:coord][0]+1,num[:coord][1])
        right = schematic.dig(num[:coord][0],num[:coord][1]+1)
        left = num[:coord][1]-1 >= 0 ? schematic.dig(num[:coord][0],num[:coord][1]-1) :  nil
        bl = num[:coord][1]-1 >= 0 ? schematic.dig(num[:coord][0]+1,num[:coord][1]-1) : nil
        br = schematic.dig(num[:coord][0]+1,num[:coord][1]+1)
        tl = num[:coord][1]-1 >= 0 && num[:coord][0]-1 >= 0 ? schematic.dig(num[:coord][0]-1,num[:coord][1]-1)  : nil
        tr = num[:coord][0]-1 >= 0 ? schematic.dig(num[:coord][0]-1,num[:coord][1]+1) : nil
        # puts [left, right, up, down, tl, tr, bl, br].inspect

        if [left, right, up, down, tl, tr, bl, br].any? { |check| check && check.match(/\D/) && check != "." }
          totals << number.map{ |n| n[:digit] }.join
          puts "Adding #{number.map{ |n| n[:digit] }.join}"
          break
        else
          puts "Not adding #{number.map{ |n| n[:digit] }.join} (row #{number[0][:coord][0] + 1})" if count == size
        end
      end
      number = []
    end

  end
end
puts totals.map(&:to_i).sum