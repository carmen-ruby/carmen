require 'spec_helper'

describe Carmen::World do

  it 'is a Region' do
    Carmen::World.is_a?(Carmen::Region).must_equal(true)
  end

  it 'has 3 subregions' do
    Carmen::World.subregions.size.must_equal(3)
  end

end
