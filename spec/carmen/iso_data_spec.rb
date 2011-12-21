require 'spec_helper'

describe "basic sanity check" do
  before do
    @__test_data_path = Carmen.data_path
    Carmen.data_path = File.expand_path('../../../iso_data', __FILE__)
  end

  after do
    Carmen.data_path = @__test_data_path
  end

  it "has 249 countries" do
    Carmen::Country.all.size.must_equal 249
  end

  it "can retrieve a country" do
    us = Carmen::Country.coded('US')
    us.instance_of?(Carmen::Country).must_equal(true, "did not find USA")
  end

  it "can retrieve a state" do
    us = Carmen::Country.coded('US')
    il = us.subregions.coded('IL')
    il.instance_of?(Carmen::Region).must_equal(true, "did not find Illinois")
  end
end
