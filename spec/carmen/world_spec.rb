require 'spec_helper'

describe Carmen::World do

  it 'is the World' do
    Carmen::World.instance.is_a?(Carmen::World).must_equal(true)
  end

  it 'has 3 subregions' do
    Carmen::World.instance.subregions.size.must_equal(3)
  end

  it 'has 2 continents' do
    Carmen::World.instance.continents.size.must_equal(2)
  end

end
