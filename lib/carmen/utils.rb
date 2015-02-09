module Carmen
  module Utils
    # Merge an array of hashes deeply.
    #
    # When a conflict occurs:
    #   - if both the old value and the new value respond_to? :merge, they
    #   are recursively passed to deep_merge_hash and the result used.
    #   - if either doesn't respond_to? :merge, then the new value is used if
    #   it is not nil. If the new value is nil, the old value is used.
    #
    # Returns a merged hash.
    def self.deep_hash_merge(hashes)
      return hashes.first if hashes.size == 1

      hashes.inject { |acc, hash|
        acc.merge(hash) { |key, old_value, new_value|
          if old_value.respond_to?(:merge) && new_value.respond_to?(:merge)
            deep_hash_merge([old_value, new_value])
          else
            new_value || old_value
          end
        }
      }
    end

    # Merge arrays of hashes using the specified keys.
    #
    # If two hashes have the same value for a key, they are merged together.
    # Otherwise, a new hash is appended to the array.
    #
    # Matching arrays uses the keys in the order they are provided.
    #
    # Returns a single merges array of hashes.
    def self.merge_arrays_by_keys(arrays, keys)
      arrays.inject do |aggregate, array|

        array.each do |new_hash|
          # Find the matching element in the agregate array
          existing = aggregate.find do |hash|
            keys.any? {|key| hash[key] && hash[key] == new_hash[key] }
          end

          # Merge the new hash to an existing one, or append it if new
          if existing
            existing.merge!(new_hash)
          else
            aggregate << new_hash
          end
        end

        aggregate
      end

    end
  end
end
