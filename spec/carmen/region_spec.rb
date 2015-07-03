# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Carmen::Region do

  describe 'basic methods' do
    before do
      @airstrip_one = Carmen::Country.coded('OC').subregions.first
    end

    it 'has a reasonable inspect value' do
      @airstrip_one.inspect.must_equal '<#Carmen::Region name="Airstrip One" type="province">'
    end
    
    it 'has a reasonable explicit string conversion' do
      "#{@airstrip_one}".must_equal 'Airstrip One'
    end

    it "has the correct subregion path" do
      @airstrip_one.subregion_data_path.must_equal "world/oc/ao.yml"
    end

    it "knows if it has subregions" do
      @airstrip_one.subregions?.must_equal true
    end

    it "has a path" do
      @airstrip_one.path.must_equal 'world.oc.ao'
    end

    describe "subregions" do
      it "is frozen" do
        subregions = Carmen::Country.coded('OC').subregions

        assert_raises RuntimeError do
          subregions.clear
        end
      end
    end

    describe "subregion" do
      before do
        @london = @airstrip_one.subregions.first
      end

      it "has a name" do
        @london.name.must_equal "London"
      end

      it "has a code" do
        @london.code.must_equal 'LO'
      end

      it "has a type" do
        @london.type.must_equal 'city'
      end

      it "has a parent" do
        @london.parent.must_equal @airstrip_one
      end
    end
  end

  describe "querying" do
    before do
      @world = Carmen::World.instance
    end

    it 'can find subregions by exact name' do
      eastasia = @world.subregions.named('Eastasia')
      eastasia.name.must_equal('Eastasia')
    end

    it "can find subregions by case-insensitive search by default" do
      eurasia = @world.subregions.named('eUrAsIa')
      eurasia.instance_of?(Carmen::Country).must_equal true
      eurasia.name.must_equal 'Eurasia'
    end

    it "can find subregions optionally case-sensitively" do
      oceania = @world.subregions.named('oCeAnIa', :case => true)
      oceania.must_equal nil
      oceania = @world.subregions.named('Oceania', :case => true)
      oceania.instance_of?(Carmen::Country).must_equal true
      oceania.name.must_equal 'Oceania'
    end

    it "can find subregions with fuzzy (substring) matching optionally" do
      eastasia = @world.subregions.named('East', :fuzzy => true)
      eastasia.instance_of?(Carmen::Country).must_equal true
      eastasia.name.must_equal 'Eastasia'
    end

    it 'can find subregions by name using a regex' do
      eastasia = @world.subregions.named(/Eastasia/)
      eastasia.name.must_equal('Eastasia')
    end

    it 'can find subregions by name using a case-insensitive regex' do
      eastasia = @world.subregions.named(/eastasia/i)
      eastasia.name.must_equal('Eastasia')
    end

    it 'handles querying for a nil code safely' do
      @world.subregions.coded(nil).must_equal nil
    end

    it 'handles querying for a nil name safely' do
      @world.subregions.named(nil).must_equal nil
    end

    describe 'unicode character handling' do
      before do
        Carmen.i18n_backend.locale = :de
      end

      after do
        Carmen.i18n_backend.locale = :en
      end

      it 'can find a country using unicode characters' do
        large = @world.subregions.named('Das großartige Staat von Eurasia')
        large.instance_of?(Carmen::Country).must_equal true
        large.name.must_equal('Das großartige Staat von Eurasia')
      end

      it 'can find a country using unicode characters' do
        large = @world.subregions.named('gross', :fuzzy => true)
        large.instance_of?(Carmen::Country).must_equal true
        large.name.must_equal('Das großartige Staat von Eurasia')
      end

    end
  end

  class SortTestRegion < Carmen::Region
    def initialize(data={}, parent=nil)
      super
      @name = data['name']
    end
    def name
      @name
    end
  end

  describe "Sorting" do
    it 'does a comparison' do
      germany = SortTestRegion.new('name' => 'Germany')
      guatemala = SortTestRegion.new('name' => 'Guatemala')
      (germany <=> guatemala).must_equal -1
      (guatemala <=> germany).must_equal 1
      (germany <=> germany).must_equal 0
    end
  end
end
