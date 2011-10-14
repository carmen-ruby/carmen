require 'spec_helper'

describe Carmen::Country do

  it "provides an API for finding countries by name" do
    us = Carmen::Country.named('United States')
    us.instance_of?(Carmen::Region).must_equal true
  end

  it "provides an API for finding countries by code" do
    us = Carmen::Country.coded('US')
    us.instance_of?(Carmen::Region).must_equal true
  end

  describe "with a country" do

    before do
      @us = Carmen::Country.coded('US')
    end

    it 'has a subregion data path' do
      expected = Carmen.data_path + 'regions/us.yml'
      @us.subregion_data_path.must_equal expected
    end

    it "has subregions" do
      @us.subregions.instance_of?(Carmen::RegionCollection).must_equal true
    end

    it "is of type :country" do
      @us.type.must_equal 'country'
    end
  end

end
