require File.expand_path('test_helper', File.dirname(__FILE__))

class TestCarmen < Test::Unit::TestCase
  
  def teardown
    Carmen.default_locale = :en # restore default
  end
  
  def test_default_countries
    assert_equal ['Aland Islands', 'AX'], Carmen.countries[1]
  end
  
  def test_localized_countries
    Carmen.default_locale = :de
    assert_equal ["Ascension (verwaltet von St. Helena)", 'AC'], Carmen.countries[0]
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
    assert_equal 'United States', Carmen.country_name('us')
  end
  
  def test_localized_country_name
    assert_equal 'Germany', Carmen.country_name('DE')
    assert_equal 'Deutschland', Carmen.country_name('DE', :locale => :de)
    Carmen.default_locale = :de
    assert_equal 'Deutschland', Carmen.country_name('DE')
  end
  
  def test_country_code
    assert_equal 'CA', Carmen.country_code('Canada')
    assert_equal 'CA', Carmen.country_code('canada')
    assert_equal 'IR', Carmen.country_code('Iran')
  end
  
  def test_localized_country_code
    assert_equal 'DE', Carmen.country_code('Deutschland', :locale => :de)
    Carmen.default_locale = :de
    assert_equal 'DE', Carmen.country_code('Deutschland')
  end
  
  def test_country_codes
    assert_equal 'AF', Carmen.country_codes.first
    assert_equal 245, Carmen.country_codes.length
  end
  
  def test_country_names
    assert_equal 'Afghanistan', Carmen.country_names.first
    assert_equal 245, Carmen.country_names.length
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
  
  def test_excluded_countries
      Carmen.excluded_countries = [ 'US', 'DE' ]
      countries = Carmen.countries
      assert !countries.include?( ["United States", "US"] )
      assert !countries.include?( ["Germany", "DE"] )
      assert countries.include?( ["Portugal", "PT"] )
      Carmen.excluded_countries = [ ]
  end

  def test_excluded_states
      Carmen.excluded_states = { 'US' => ['IL', 'OR'], 'DE' => ['BE', 'HH'] }
      states = Carmen.states
      assert !states.include?( ["Illinois", "IL"] )
      assert !states.include?( ["Oregon", "OR"] )
      assert states.include?( ["Kentucky", "KY"] )

      states = Carmen.states("DE")
      assert !states.include?( ["Berlin", "BE"] )
      assert !states.include?( ["Hamburg", "HH"] )
      assert states.include?( ["Rheinland-Pfalz", "RP"] )

      states = Carmen.states("ES")
      assert states.include?( ["Cantabria", "CAN"] )

      Carmen.excluded_states = {}
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
