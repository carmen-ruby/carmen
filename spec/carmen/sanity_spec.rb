require 'spec_helper'

describe "default data sanity check" do
  before do
    Carmen.reset_data_paths
    Carmen.reset_i18n_backend
  end

  after do
    setup_carmen_test_i18n_backend
    setup_carmen_test_data_path
  end

  it "has 248 countries" do
    _(Carmen::Country.all.size).must_equal 249
  end

  it "can retrieve a country" do
    us = Carmen::Country.coded('US')
    _(us.instance_of?(Carmen::Country)).must_equal(true, "did not find USA")
    _(us.name).must_equal('United States')
  end

  it "can retrieve a state" do
    us = Carmen::Country.coded('US')
    il = us.subregions.coded('IL')
    _(il.instance_of?(Carmen::Region)).must_equal(true, "did not find Illinois")
    _(il.name).must_equal('Illinois')
  end

  it "observes locale data in the overlay directory" do
    tw = Carmen::Country.coded('TW')
    _(tw.name).must_equal('Taiwan')
  end
end
