require 'spec_helper'

describe "basic sanity check" do
  before do
    @__test_data_path = Carmen.data_path
    @__test_locale_paths = Carmen.i18n_backend.locale_paths
    Carmen.data_path = File.expand_path('../../../iso_data', __FILE__)
    locale_path = File.expand_path('../../../locale', __FILE__)
    Carmen.i18n_backend = Carmen::I18n::Simple.new(locale_path)
  end

  after do
    Carmen.data_path = @__test_data_path
    Carmen.i18n_backend = Carmen::I18n::Simple.new(@__test_locale_paths)
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
