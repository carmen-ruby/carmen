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

    # Filters the regions in this collection by type.
    #
    # type - The String type to filter by
    #
    # Returns a region collection containing all the regions with the supplied
    # type.
    def typed(type)
      downcased_type = type.downcase
      results = select{ |r| r.type == downcased_type }
      Carmen::RegionCollection.new(results)
    end

  private

    def query_collection
      self
    end

    def attribute_to_search_for_code(code)
      :code
    end

  end
end
