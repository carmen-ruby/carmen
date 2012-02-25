require 'spec_helper'

describe "Data overlaying" do

  before do
    Carmen.overlay_path = File.expand_path('../../overlay/data', __FILE__)
  end

  after do
    Carmen.overlay_path = nil
  end

  it 'finds elements that exist only in overlay files' do
    sealand = Carmen::Country.coded('SE')
    sealand.instance_of?(Carmen::Country).must_equal true
    sealand.type.must_equal('fort')
  end

  it 'removes elements that have _enabled set to false' do
    Carmen::World.instance.subregions.size.must_equal(3)
    Carmen::Country.named('Eurasia').must_equal nil
  end

end
