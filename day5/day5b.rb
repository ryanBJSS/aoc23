def line_to_seed_reverse_lookup(map, seed_to_lookup)
  parsed_map = map.split(":")[1].strip.split("\n").map do |line|
    value, key, range = line.split(" ").map(&:to_i)
    { key: key, value: value, range: range }
  end

  key = parsed_map.select do |line|
    seed_to_lookup >= line[:value] && (seed_to_lookup <= (line[:value] + line[:range]))
  end.first

  if key.nil?
    seed_to_lookup
  else
    offset = seed_to_lookup - key[:value]
    key[:key] + offset
  end
end

whole_file = File.readlines("input.txt")



seeds_line, seeds_to_soil, soil_to_fertiliser, fertiliser_to_water, water_to_light, light_to_temp, temp_to_hum, hum_to_loc = whole_file.join.split("\n\n")




seeds_to_find_raw = seeds_line.split(":")[1].strip.split(" ").map(&:to_i)

seeds_to_find = []
seeds_to_find_raw.each_slice(2) do |a, b|
  seeds_to_find << { start: a, end: a + b }
end

seeds_to_find = seeds_to_find.flatten
pp seeds_to_find


locations = hum_to_loc.split(":")[1].strip.split("\n").map do |line|
  value, key, range = line.split(" ").map(&:to_i)
  { key: key, value: value, range: range }
end



i = 0
while true do

    seed = line_to_seed_reverse_lookup(seeds_to_soil, line_to_seed_reverse_lookup(soil_to_fertiliser, line_to_seed_reverse_lookup(fertiliser_to_water, line_to_seed_reverse_lookup(water_to_light, line_to_seed_reverse_lookup(light_to_temp, line_to_seed_reverse_lookup(temp_to_hum, line_to_seed_reverse_lookup(hum_to_loc, i)))))))
    looked_up_val = seeds_to_find.select { |h| seed >= h[:start]  && seed <= h[:end] }.first
    if looked_up_val
      puts "*******"
      puts i
      puts "*******"
      break
    end
    i +=1
    pp i if i % 100000 == 0
end



