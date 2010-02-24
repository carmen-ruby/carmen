require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/carmen')

class TestCarmen < Test::Unit::TestCase
  
  def test_default_countries
    assert_equal ['Aland Islands', 'AX'], Carmen.countries[1]
  end
  
  def test_localized_countries
    Carmen.locale = :de
    assert_equal ["Ascension (verwaltet von St. Helena)", 'AC'], Carmen.countries[0]
    Carmen.locale = :en # restore default
  end
  
  def test_single_localized_countries_call
    # Check that we are working with the default
    assert_equal ['Aland Islands', 'AX'], Carmen.countries[1]
    
    # Switch to a different locale for one call
    assert_equal ["Ascension (verwaltet von St. Helena)", 'AC'], Carmen.countries(:locale => 'de')[0]
    
    # Make sure that we are back in the default locale
    assert_equal ['Aland Islands', 'AX'], Carmen.countries[1]
  end
  
  def test_country_name
    assert_equal 'United States', Carmen.country_name('US')
  end
  
  def test_localized_country_name
    Carmen.locale = :de
    assert_equal 'Deutschland', Carmen.country_name('DE')
    Carmen.locale = :en # restore default
  end
  
  def test_country_code
    assert_equal 'CA', Carmen.country_code('Canada')
  end
  
  def test_localized_country_code
    Carmen.locale = :de
    assert_equal 'DE', Carmen.country_code('Deutschland')
    Carmen.locale = :en # restore default
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
    assert_equal 61, Carmen.states.length
    assert_equal ['Alabama', 'AL'], Carmen.states.first
    assert_equal 13, Carmen.states('CA').length
    assert_equal ['Alberta', 'AB'], Carmen.states('CA').first
  end
  
  def test_state_names
    assert_equal 61, Carmen::state_names.length
    assert_equal 'Alabama', Carmen::state_names.first
    assert_equal 13, Carmen.state_names('CA').length
    assert_equal 'Alberta', Carmen.state_names('CA').first
  end
  
  def test_state_codes
    assert_equal 61, Carmen::state_codes.length
    assert_equal 'AL', Carmen::state_codes.first
    assert_equal 13, Carmen.state_codes('CA').length
    assert_equal 'AB', Carmen.state_codes('CA').first
  end
  
  def test_supported_states
    assert Carmen::states?('US')
    assert_equal Carmen::states?('ZZ'), false
  end
  
  def test_invalid_country_exception
    assert_raises Carmen::NonexistentCountry do
      Carmen::state_codes('ZZ')
    end
  end
  
  def test_unsupported_states_exception
    assert_raises Carmen::StatesNotSupported do
      Carmen::state_codes('ID')
    end
  end
  
  def test_unsupported_locale
    assert_raises Carmen::UnavailableLocale do
      Carmen.countries(:locale => :latin)
    end
  end
  
end