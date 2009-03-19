require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/carmen')

class TestCarmen < Test::Unit::TestCase
  
  def test_country_name
    assert_equal 'United States', Carmen.country_name('US')
  end
  
  def test_country_code
    assert_equal 'CA', Carmen.country_code('Canada')
  end
  
  def test_country_codes
    assert_equal 'AF', Carmen.country_codes.first
    assert_equal 243, Carmen.country_codes.length
  end
  
  def test_country_names
    assert_equal 'Afghanistan', Carmen.country_names.first
    assert_equal 243, Carmen.country_names.length
  end
  
  def test_state_name
    assert_equal 'IL', Carmen.state_code('Illinois')
    assert_equal 'MB', Carmen.state_code('Manitoba', 'CA')
  end
  
  def test_state_code
    assert_equal 'Arizona', Carmen.state_name('AZ')
    assert_equal 'Prince Edward Island', Carmen.state_name('PE', 'CA')
  end
  
  def test_states
    assert_equal 51, Carmen.states.length
    assert_equal ['Alabama', 'AL'], Carmen.states.first
    assert_equal 13, Carmen.states('CA').length
    assert_equal ['Alberta', 'AB'], Carmen.states('CA').first
  end
  
  def test_state_names
    assert_equal 51, Carmen::state_names.length
    assert_equal 'Alabama', Carmen::state_names.first
    assert_equal 13, Carmen.state_names('CA').length
    assert_equal 'Alberta', Carmen.state_names('CA').first
  end
  
  def test_state_codes
    assert_equal 51, Carmen::state_codes.length
    assert_equal 'AL', Carmen::state_codes.first
    assert_equal 13, Carmen.state_codes('CA').length
    assert_equal 'AB', Carmen.state_codes('CA').first
  end
  
end