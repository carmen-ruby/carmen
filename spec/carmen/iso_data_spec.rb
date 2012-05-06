require 'spec_helper'

describe "basic sanity check" do
  before do
    Carmen.reset_data_paths
    Carmen.reset_i18n_backend
  end

  after do
    setup_carmen_test_i18n_backend
    setup_carmen_test_data_path
  end

  it "has 249 countries" do
    Carmen::Country.all.size.must_equal 249
  end

  it "can retrieve a country" do
    us = Carmen::Country.coded('US')
    us.instance_of?(Carmen::Country).must_equal(true, "did not find USA")
    us.name.must_equal('United States')
  end

  it "can retrieve a state" do
    us = Carmen::Country.coded('US')
    il = us.subregions.coded('IL')
    il.instance_of?(Carmen::Region).must_equal(true, "did not find Illinois")
    il.name.must_equal('Illinois')
  end
end
