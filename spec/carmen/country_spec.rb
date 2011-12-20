require 'spec_helper'

describe Carmen::Country do

  it "provides an API for finding countries by name" do
    eastasia = Carmen::Country.named('Eastasia')
    eastasia.instance_of?(Carmen::Region).must_equal true
  end

  it "provides an API for finding countries by code" do
    eurasia = Carmen::Country.coded('EU')
    eurasia.instance_of?(Carmen::Region).must_equal true
  end

  it "is of type :country" do
    @oceania = Carmen::Country.coded('OC')
    @oceania.type.must_equal 'country'
  end

  describe "a country with subregions" do
    before do
      @oceania = Carmen::Country.coded('OC')
    end

    it 'has a subregion data path' do
      expected = Carmen.data_path + 'regions/oc.yml'
      @oceania.subregion_data_path.must_equal expected
    end

    it "has subregions" do
      @oceania.subregions?.must_equal true
    end

    it "has subregions" do
      @oceania.subregions.instance_of?(Carmen::RegionCollection).must_equal true
      @oceania.subregions.size.must_equal 1
    end
  end

  describe "a country without subregions" do
    before do
      @eastasia = Carmen::Country.coded('ES')
    end

    it "has no subregions" do
      @eastasia.subregions?.must_equal false
    end

    it "has an empty subregions collection" do
      @eastasia.subregions.must_equal []
    end
  end

end
