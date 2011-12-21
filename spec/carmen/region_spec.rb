require 'spec_helper'

describe Carmen::Region do

  it 'has a reasonable inspect value' do
    oceania = Carmen::Country.coded('OC').subregions.first
    oceania.inspect.must_equal '<#Carmen::Region name="Airstrip One" type="providence">'
  end

end
