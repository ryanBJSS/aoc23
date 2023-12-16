def hash(label)
  label.chars.inject(0) { |memo, char| (memo + char.ord) * 17 % 256 }
end

# Part 1
p File.readlines('input.txt').first.split(',').map { |segment| hash(segment) }.sum

# Part 2
p(Hash.new { |hash, key| hash[key] = {} }.tap do |boxes|
  File.readlines('input.txt').first.split(',').each do |instruction|
    if instruction.chars.include?('=')
      label, power = instruction.split('=')
      boxes[hash(label)][label] = power.to_i
    else
      label = instruction.split('-').first
      boxes[hash(label)].delete(label)
    end
  end
end.map { |label, lenses| lenses.map.with_index { |(_, power), i| (label + 1) * power * (i + 1) }.sum }.sum)