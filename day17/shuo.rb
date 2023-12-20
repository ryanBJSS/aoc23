N, E, S, W = [-1, 0], [0, 1], [1, 0], [0, -1]

map = File.readlines('input.txt', chomp: true).map { |row| row.chars.map(&:to_i) }

START = [0, 0]
FINISH = [map.size - 1, map[0].size - 1]

queue = []
visited = Hash.new(Float::INFINITY)

queue << { position: START, direction: E, heat_loss: 0, steps: 0 }
queue << { position: START, direction: S, heat_loss: 0, steps: 0 }

final_heat_losses = []

while (path = queue.shift) do
  # Cannot U turn
  next_directions = [N, E, S, W] - [ path[:direction].map { |n| n * -1 } ]
  # Must change direction
  if path[:steps] == 3
    next_directions -= [path[:direction]]
  end

  next_directions.each do |next_direction|
    next_position = [path[:position][0] + next_direction[0], path[:position][1] + next_direction[1]]

    # next step is within the map boundaries
    next unless next_position[0] >= 0 && next_position[0] < map.size &&
      next_position[1] >= 0 && next_position[1] < map[0].size

    next_steps = if next_direction == path[:direction]
                   path[:steps] + 1
                 else
                   1
                 end

    next_heat_loss = path[:heat_loss] + map[next_position[0]][next_position[1]]
    if next_position == FINISH
      final_heat_losses << next_heat_loss
    end

    if visited[[next_position, next_direction, next_steps]] <= next_heat_loss
      next
    else
      visited[[next_position, next_direction, next_steps]] = next_heat_loss
      queue << { position: next_position, direction: next_direction, heat_loss: next_heat_loss, steps: next_steps }
    end
  end
end

pp final_heat_losses.count
puts final_heat_losses.min