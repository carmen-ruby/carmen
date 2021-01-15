# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Carmen::Region do

  describe 'basic methods' do
    before do
      @airstrip_one = Carmen::Country.coded('OC').subregions.first
    end

    it 'has a reasonable inspect value' do
      _(@airstrip_one.inspect).must_equal '<#Carmen::Region name="Airstrip One" type="province">'
    end
    
    it 'has a reasonable explicit string conversion' do
      _("#{@airstrip_one}").must_equal 'Airstrip One'
    end

    it "has the correct subregion path" do
      _(@airstrip_one.subregion_data_path).must_equal "world/oc/ao.yml"
    end

    it "knows if it has subregions" do
      _(@airstrip_one.subregions?).must_equal true
    end

    it "has a path" do
      _(@airstrip_one.path).must_equal 'world.oc.ao'
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
        _(@london.name).must_equal "London"
      end

      it "has a code" do
        _(@london.code).must_equal 'LO'
      end

      it "has a type" do
        _(@london.type).must_equal 'city'
      end

      it "has a parent" do
        _(@london.parent).must_equal @airstrip_one
      end
    end
  end

  describe "querying" do
    before do
      @world = Carmen::World.instance
    end

    it 'can find subregions by exact name' do
      eastasia = @world.subregions.named('Eastasia')
      _(eastasia.name).must_equal('Eastasia')
    end

    it "can find subregions by case-insensitive search by default" do
      eurasia = @world.subregions.named('eUrAsIa')
      _(eurasia.instance_of?(Carmen::Country)).must_equal true
      _(eurasia.name).must_equal 'Eurasia'
    end

    it "can find subregions optionally case-sensitively" do
      oceania = @world.subregions.named('oCeAnIa', :case => true)
      assert_nil(oceania)
      oceania = @world.subregions.named('Oceania', :case => true)
      _(oceania.instance_of?(Carmen::Country)).must_equal true
      _(oceania.name).must_equal 'Oceania'
    end

    it "can find subregions with fuzzy (substring) matching optionally" do
      eastasia = @world.subregions.named('East', :fuzzy => true)
      _(eastasia.instance_of?(Carmen::Country)).must_equal true
      _(eastasia.name).must_equal 'Eastasia'
    end

    it 'can find subregions with dash or hyphen in name ' do
      @airstrip_one = Carmen::Country.coded('OC').subregions.named('Airstrip-One', :fuzzy => true)
      _("#{@airstrip_one}").must_equal 'Airstrip One'
      @airstrip_two_without_dash = Carmen::Country.coded('OC').subregions.named('Airstrip Two', :fuzzy => true)
      _("#{@airstrip_two_without_dash}").must_equal 'Airstrip-Two'
      @airstrip_two = Carmen::Country.coded('OC').subregions.named('Airstrip-Two', :fuzzy => true)
      _("#{@airstrip_two}").must_equal 'Airstrip-Two'
    end

    it 'can find subregions by name using a regex' do
      eastasia = @world.subregions.named(/Eastasia/)
      _(eastasia.name).must_equal('Eastasia')
    end

    it 'can find subregions by name using a case-insensitive regex' do
      eastasia = @world.subregions.named(/eastasia/i)
      _(eastasia.name).must_equal('Eastasia')
    end

    it 'handles querying for a nil code safely' do
      assert_nil(@world.subregions.coded(nil))
    end

    it 'handles querying for a nil name safely' do
      assert_nil(@world.subregions.named(nil))
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
        _(large.instance_of?(Carmen::Country)).must_equal true
        _(large.name).must_equal('Das großartige Staat von Eurasia')
      end

      it 'can find a country using unicode characters' do
        large = @world.subregions.named('gross', :fuzzy => true)
        _(large.instance_of?(Carmen::Country)).must_equal true
        _(large.name).must_equal('Das großartige Staat von Eurasia')
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
      _(germany <=> guatemala).must_equal -1
      _(guatemala <=> germany).must_equal 1
      _(germany <=> germany).must_equal 0
    end
  end
end
