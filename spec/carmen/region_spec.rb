require 'spec_helper'

describe Carmen::Region do

  it 'has a reasonable inspect value' do
    us = Carmen::Country.coded('US')
    us.inspect.must_equal '<#Carmen::Region type=country subregions?=true>'
  end

end
