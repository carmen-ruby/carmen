module Carmen
  module Querying

    # Find a region by code.
    #
    # code - The String code to search for
    #
    # Returns a region with the supplied code, or nil ir none is found.
    def coded(code)
      attribute = case code.to_s.size
      when 2
        :alpha_2_code
      when 3
        :alpha_3_code
      else
        fail "coded only accepts 2 or 3 character codes"
      end
      subregions.find do |region|
        region.send(attribute) == code
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
