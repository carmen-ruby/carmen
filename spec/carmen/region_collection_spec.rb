require 'spec_helper'

describe Carmen::RegionCollection do

  before do
    @collection = Carmen::RegionCollection.new([
      Carmen::Region.new('type' => 'custom_type1', 'code' => 'AA'),
      Carmen::Region.new('type' => 'custom_type2', 'code' => 'BB')
    ])
  end

  it 'provides an API for filtering regions by type' do
    @collection.typed('custom_type1').map(&:code).must_equal ['AA']
  end

end
