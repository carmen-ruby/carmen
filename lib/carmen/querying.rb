require 'active_support/core_ext/string'

module Carmen
  module Querying
    # Find a region by code.
    #
    # code - The String code to search for
    #
    # Returns a region with the supplied code, or nil if none is found.
    def coded(code)
      return nil if code.nil?
      attribute = attribute_to_search_for_code(code)
      if attribute.nil?
        fail "could not find an attribute to search for code '#{code}'"
      end
      code = code.downcase # Codes are all ASCII
      query_collection.find do |region|
        region.send(attribute).downcase == code
      end
    end

    # Find a region by name.
    #
    # name - The String name to search for.
    # options - The Hash options used to modify the search (default:{}):
    #           :fuzzy - Whether to use fuzzy matching when finding a
    #                    matching name (optional, default: false)
    #           :case  - Whether or not the match is case-sensitive
    #                    (optional, default: false)
    #
    # Returns a region with the supplied name, or nil if none if found.
    def named(name, options={})
      case_fold = !options[:case] && name.respond_to?(:each_codepoint)
      # These only need to be built once
      name = case_fold ? name.mb_chars.downcase.normalize : name
      # For now, "fuzzy" just means substring, optionally case-insensitive (the second argument looks for nil, not falseness)
      regexp = options[:fuzzy] ? Regexp.new(name, options[:case] ? nil : true) : nil

      query_collection.find do |region|
        found_literal = name === (case_fold && region.name ? region.name.mb_chars.downcase.normalize : region.name)
        found_literal || options[:fuzzy] && regexp === region.name
      end
    end

  end
end
