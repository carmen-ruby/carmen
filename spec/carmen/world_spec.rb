require 'spec_helper'

describe Carmen::World do

  it 'is the World' do
    _(Carmen::World.instance.is_a?(Carmen::World)).must_equal(true)
  end

  it 'has 3 subregions' do
    _(Carmen::World.instance.subregions.size).must_equal(3)
  end

end
