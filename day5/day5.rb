def line_to_seed_lookup(map, seed_to_lookup)
  parsed_map = map.split(":")[1].strip.split("\n").map do |line|
    value, key, range = line.split(" ").map(&:to_i)
    { key: key, value: value, range: range }
  end

  seed = parsed_map.select do |line|
    seed_to_lookup >= line[:key] && (seed_to_lookup <= (line[:key] + line[:range]))
  end.first

  if seed.nil?
    seed_to_lookup
  else
    offset = seed_to_lookup - seed[:key]
    seed[:value] + offset
  end
end

whole_file = File.readlines("input.txt")

seeds_line, seeds_to_soil, soil_to_fertiliser, fertiliser_to_water, water_to_light, light_to_temp, temp_to_hum, hum_to_loc = whole_file.join.split("\n\n")

seeds_to_find = seeds_line.split(":")[1].strip.split(" ").map(&:to_i)

min = seeds_to_find.map do |seed|
  line_to_seed_lookup(hum_to_loc,
      line_to_seed_lookup(temp_to_hum, line_to_seed_lookup(light_to_temp,
                         line_to_seed_lookup(water_to_light,
                                                            line_to_seed_lookup(fertiliser_to_water,
                                                                                line_to_seed_lookup(soil_to_fertiliser,
                                                                                                    line_to_seed_lookup(seeds_to_soil, seed)))))))
end.min

puts min




