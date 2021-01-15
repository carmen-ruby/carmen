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
    _(sealand.instance_of?(Carmen::Country)).must_equal true
    _(sealand.type).must_equal('fort')
  end

  it 'still finds elements that exist only in gem files' do
    oceania = Carmen::Country.coded('OC')
    _(oceania.instance_of?(Carmen::Country)).must_equal true
    _(oceania.type).must_equal('country')
  end

  it 'still finds subregions that exist only in gem files' do
    oceania = Carmen::Country.coded('OC')
    _(oceania.subregions?).must_equal true
    _(oceania.subregions.named("Airstrip One").type).must_equal("province")
  end

  it 'removes elements that have _enabled set to false' do
    _(Carmen::World.instance.subregions.size).must_equal(3)
    assert_nil(Carmen::Country.named('Eurasia'))
  end

end
