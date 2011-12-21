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

  private

    def query_collection
      self
    end

    def attribute_to_search_for_code(code)
      :code
    end

  end
end
