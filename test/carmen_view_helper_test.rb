require 'rubygems'
require 'active_support'
require 'action_view'
require 'action_controller'
require 'action_view/test_case'
require 'mocha'
require File.join(File.dirname(__FILE__), '../lib/carmen')
require File.join(File.dirname(__FILE__), '../lib/carmen/action_view_helpers')

class CarmenViewHelperTest < ActionView::TestCase
  
  include ActionView::Helpers::FormOptionsHelper
  
  def setup
    @address = stub(:state => 'IL', :to_s => 'address')
  end
  
  def test_state_select_for_us
    @address.stubs(:state => 'nil')
    assert_equal US_STATE_SELECT_HTML.chomp, state_select(@address, :state, 'US')
  end
  
  def test_state_select_for_canada
    @address.stubs(:state => 'nil')
    assert_equal CANADA_STATE_SELECT_HTML.chomp, state_select(@address, :state, 'CA')
  end
  
  def test_selected_option
    @address.stubs(:state => 'ON')
    assert_match /<option value="ON" selected="selected">Ontario<\/option>/, state_select(@address, :state, 'CA')
  end
  
  US_STATE_SELECT_HTML = "<select id=\"address_state\" name=\"address[state]\"><option value=\"AL\">Alabama</option>\n<option value=\"AK\">Alaska</option>\n<option value=\"AZ\">Arizona</option>\n<option value=\"AR\">Arkansas</option>\n<option value=\"CA\">California</option>\n<option value=\"CO\">Colorado</option>\n<option value=\"CT\">Connecticut</option>\n<option value=\"DE\">Delaware</option>\n<option value=\"DC\">District Of Columbia</option>\n<option value=\"FL\">Florida</option>\n<option value=\"GA\">Georgia</option>\n<option value=\"HI\">Hawaii</option>\n<option value=\"ID\">Idaho</option>\n<option value=\"IL\">Illinois</option>\n<option value=\"IN\">Indiana</option>\n<option value=\"IA\">Iowa</option>\n<option value=\"KS\">Kansas</option>\n<option value=\"KY\">Kentucky</option>\n<option value=\"LA\">Louisiana</option>\n<option value=\"ME\">Maine</option>\n<option value=\"MD\">Maryland</option>\n<option value=\"MA\">Massachusetts</option>\n<option value=\"MI\">Michigan</option>\n<option value=\"MN\">Minnesota</option>\n<option value=\"MS\">Mississippi</option>\n<option value=\"MO\">Missouri</option>\n<option value=\"MT\">Montana</option>\n<option value=\"NE\">Nebraska</option>\n<option value=\"NV\">Nevada</option>\n<option value=\"NH\">New Hampshire</option>\n<option value=\"NJ\">New Jersey</option>\n<option value=\"NM\">New Mexico</option>\n<option value=\"NY\">New York</option>\n<option value=\"NC\">North Carolina</option>\n<option value=\"ND\">North Dakota</option>\n<option value=\"OH\">Ohio</option>\n<option value=\"OK\">Oklahoma</option>\n<option value=\"OR\">Oregon</option>\n<option value=\"PA\">Pennsylvania</option>\n<option value=\"RI\">Rhode Island</option>\n<option value=\"SC\">South Carolina</option>\n<option value=\"SD\">South Dakota</option>\n<option value=\"TN\">Tennessee</option>\n<option value=\"TX\">Texas</option>\n<option value=\"UT\">Utah</option>\n<option value=\"VT\">Vermont</option>\n<option value=\"VA\">Virginia</option>\n<option value=\"WA\">Washington</option>\n<option value=\"WV\">West Virginia</option>\n<option value=\"WI\">Wisconsin</option>\n<option value=\"WY\">Wyoming</option></select>"
  
  CANADA_STATE_SELECT_HTML = "<select id=\"address_state\" name=\"address[state]\"><option value=\"AB\">Alberta</option>\n<option value=\"BC\">British Columbia</option>\n<option value=\"MB\">Manitoba</option>\n<option value=\"NB\">New Brunswick</option>\n<option value=\"NL\">Newfoundland and Labrador</option>\n<option value=\"NT\">Northwest Territories</option>\n<option value=\"NS\">Nova Scotia</option>\n<option value=\"NU\">Nunavut</option>\n<option value=\"ON\">Ontario</option>\n<option value=\"PE\">Prince Edward Island</option>\n<option value=\"QC\">Quebec</option>\n<option value=\"SK\">Saskatchewan</option>\n<option value=\"YT\">Yukon</option></select>"
  
end