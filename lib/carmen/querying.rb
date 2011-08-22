module Carmen
  module Querying

    # Find a region by code.
    #
    # code - The String code to search for
    #
    # Returns a region with the supplied code, or nil ir none is found.
    def coded(code)
      subregions.find do |region|
        region.code == code
      end
    end

    # Find a region by name.
    #
    # name - The String name to search for.
    # options - The Hash options used to modify the search (default:{}):
    #           :fuzzy - Whether to use fuzzy matching when finding a
    #           matching name (optional, default: false)
    #
    # Returns a region with the supplied name, or nil if none if found.
    def named(name, options={})
      subregions.find do |region|
        region.name == name
      end
    end

  end
end
