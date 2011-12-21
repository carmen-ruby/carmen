require 'spec_helper'

describe Carmen::Country do

  it "provides access to all countries" do
    countries = Carmen::Country.all
    countries.size.must_equal 3
  end

  it "provides an API for finding countries by name" do
    eastasia = Carmen::Country.named('Eastasia')
    eastasia.instance_of?(Carmen::Country).must_equal true
  end

  it "provides an API for finding countries by code" do
    eurasia = Carmen::Country.coded('EU')
    eurasia.instance_of?(Carmen::Country).must_equal true
  end

  describe "basic attributes" do
    before do
      @oceania = Carmen::Country.coded('OC')
    end

    it "is of type :country" do
      @oceania.type.must_equal 'country'
    end

    it "has a name" do
      @oceania.name.must_equal 'Oceania'
    end

    it "has a 2 character code" do
      @oceania.alpha_2_code.must_equal 'OC'
    end

    it "has a 3 character code" do
      @oceania.alpha_3_code.must_equal 'OCE'
    end

    it "has the world as a parent" do
      @oceania.parent.must_equal Carmen::World.instance
    end

    it 'has a reasonable inspect value' do
      @oceania.inspect.must_equal '<#Carmen::Country name="Oceania">'
    end
  end

  describe "a country with subregions" do
    before do
      @oceania = Carmen::Country.coded('OC')
    end

    it 'has a subregion data path' do
      expected = Carmen.data_path + 'world/oc.yml'
      @oceania.subregion_data_path.must_equal expected
    end

    it "has subregions" do
      @oceania.subregions?.must_equal true
    end

    it "has subregions" do
      @oceania.subregions.instance_of?(Carmen::RegionCollection).must_equal true
      @oceania.subregions.size.must_equal 1
    end

    it "loads all attributes for subregions" do
      airstrip_one = @oceania.subregions.first

      airstrip_one.name.must_equal "Airstrip One"
      airstrip_one.type.must_equal "providence"
      airstrip_one.code.must_equal "OC-AO"
    end

    it "sets itself as the parent of a subregions" do
      airstrip_one = @oceania.subregions.first
      airstrip_one.parent.must_equal @oceania
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
