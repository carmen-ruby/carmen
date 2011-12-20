require 'spec_helper'

describe Carmen::Region do

  it 'has a reasonable inspect value' do
    oceania = Carmen::Country.coded('OC')
    oceania.inspect.must_equal '<#Carmen::Region type=country subregions?=true>'
  end

end
