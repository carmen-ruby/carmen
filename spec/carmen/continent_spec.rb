require 'spec_helper'

describe Carmen::Continent do

  describe "#initialize when given a string of contained-country-codes" do

    it "will interpret them as carmen-countries and set them as contained_continents_or_countries" do
      continent = Carmen::Continent.new({'territory' => '001', 'contains' => ['002', '003', '004']})

      continent.sub_continents.count.must_equal 3
      continent.sub_continents[0].class.must_equal Carmen::Continent
      continent.sub_continents[1].class.must_equal Carmen::Continent
      continent.sub_continents[2].class.must_equal Carmen::Continent
    end
  end

  describe "#initialize when given a string of contained-continent-codes" do
    it "will interpret them as carmen-continents and set them as contained_continents_or_countries" do
      continent = Carmen::Continent.new({'territory' => '011', 'contains' => ['OC','EU']})

      continent.countries.count.must_equal 2
      continent.countries[0].class.must_equal Carmen::Country
      continent.countries[1].class.must_equal Carmen::Country
    end
  end

  describe '#coded' do
    it 'gets the continent with the given code' do
      continent = Carmen::Continent.coded('003')
      continent.name.must_equal 'Waterworld'
      continent.code.must_equal '003'

      continent.sub_continents.count.must_equal 2
      continent.countries.count.must_equal 0
    end
  end

  describe '#name' do
    it 'uses the i18n-backend to fetch the correct name' do
      continent = Carmen::Continent.coded('002')
      continent.name.must_equal 'Junglolia'

      continent = Carmen::Continent.coded('003')
      continent.name.must_equal 'Waterworld'
    end
  end

  describe '#sub_continents' do
    it 'returns the sub_continents of the given continent' do
      Carmen::Continent.coded('001').sub_continents.count.must_equal 2
      Carmen::Continent.coded('001').sub_continents[0].code.must_equal "002"
      Carmen::Continent.coded('001').sub_continents[1].code.must_equal "003"
    end
  end

  describe '#countries' do
    it 'returns the countries of the given continent if NO sub_continents are present' do
      Carmen::Continent.coded('004').countries.count.must_equal 3
    end

    it 'finds all countries of all sub_continents if some are present' do
      Carmen::Continent.coded('001').countries.count.must_equal 3
    end
  end

  describe '#all' do
    it 'returns all existing continents of all hierachies' do
      Carmen::Continent.all.count.must_equal 6
    end
  end

end
