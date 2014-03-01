require 'spec_helper'

describe "Data overlaying" do

  before do
    Carmen.append_data_path(carmen_spec_overlay_data_path)
  end

  after do
    setup_carmen_test_data_path
  end

  it 'finds elements that exist only in overlay files' do
    sealand = Carmen::Country.coded('SE')
    sealand.instance_of?(Carmen::Country).must_equal true
    sealand.type.must_equal('fort')
  end

  it 'still finds elements that exist only in gem files' do
    oceania = Carmen::Country.coded('OC')
    oceania.instance_of?(Carmen::Country).must_equal true
    oceania.type.must_equal('country')
  end

  it 'still finds subregions that exist only in gem files' do
    oceania = Carmen::Country.coded('OC')
    oceania.subregions?.must_equal true
    oceania.subregions.named("Airstrip One").type.must_equal("province")
  end

  it 'removes elements that have _enabled set to false' do
    Carmen::World.instance.subregions.size.must_equal(3)
    Carmen::Country.named('Eurasia').must_equal nil
  end

end
