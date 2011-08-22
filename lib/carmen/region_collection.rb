require 'carmen/querying'

module Carmen
  # RegionCollection is responsible for holding the subregions for a
  # region and also provides an interface to query said subregions.
  #
  # Example:
  #
  #   states = Carmen::Country.coded('US').subregions
  #   => #<RegionCollection>
  #   states.size
  #   => 5
  #   states.named('Illinois')
  #   => #<Region name:"Illinois" code: "IL">
  #
  class RegionCollection < Array
    include Querying
  end
end
