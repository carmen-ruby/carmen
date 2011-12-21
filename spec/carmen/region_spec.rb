require 'spec_helper'

describe Carmen::Region do
  before do
    @airstrip_one = Carmen::Country.coded('OC').subregions.first
  end

  it 'has a reasonable inspect value' do
    @airstrip_one.inspect.must_equal '<#Carmen::Region name="Airstrip One" type="providence">'
  end

  it "has the correct subregion path" do
    expected_path = Carmen.data_path + "world/oc/ao.yml"
    @airstrip_one.subregion_data_path.must_equal expected_path
  end

  it "knows if it has subregions" do
    @airstrip_one.subregions?.must_equal true
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

end
