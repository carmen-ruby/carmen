require 'spec_helper'

describe Carmen::Region do
  before do
    @airstrip_one = Carmen::Country.coded('OC').subregions.first
  end

  it 'has a reasonable inspect value' do
    @airstrip_one.inspect.must_equal '<#Carmen::Region name="Airstrip One" type="providence">'
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

  describe "Basic querying" do
    before do
      @world = Carmen::World.instance
    end

    it 'can find subregions by exact name' do
      eastasia = @world.subregions.named('Eastasia')
      eastasia.name.must_equal('Eastasia')
    end

    it 'can find subregions by name using a regex' do
      eastasia = @world.subregions.named(/Eastasia/)
      eastasia.name.must_equal('Eastasia')
    end

    it 'can find subregions by name using a case-insensitive regex' do
      eastasia = @world.subregions.named(/eastasia/i)
      eastasia.name.must_equal('Eastasia')
    end
  end
end
