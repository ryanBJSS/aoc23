require_relative 'day12'

RSpec.describe 'day 12' do           #
  # it 'example one' do   #
  #   expect(day12("???.###", [1,1,3])).to eq 1
  # end
  #
  # it 'example 2' do   #
  #   expect(day12(".??..??...?##.", [1,1,3])).to eq 4
  # end

  it 'example 6' do
    expect(day12("?###????????", [3,2,1])).to eq 10
  end
end