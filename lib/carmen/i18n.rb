require 'yaml'
require 'carmen/utils'

module Carmen
  module I18n

    # A simple object to handle I18n translation in simple situations.
    class Simple

      DEFAULT_LOCALE = 'en'

      attr_accessor :cache
      attr_reader :fallback_locale
      attr_reader :locale_paths

      def initialize(*initial_locale_paths)
        self.locale = DEFAULT_LOCALE
        @fallback_locale = DEFAULT_LOCALE
        @locale_paths = []
        initial_locale_paths.each do |path|
          append_locale_path(path)
        end
      end

      def append_locale_path(path)
        reset!
        @locale_paths << Pathname.new(path)
      end

      # Set a new locale
      #
      # Calling this method will clear the cache.
      def locale=(locale)
        Thread.current[:carmen_locale] = locale.to_s
      end

      def locale
        Thread.current[:carmen_locale]
      end

      # Retrieve a translation for a key in the following format: 'a.b.c'
      #
      # This will attempt to find the key in the current locale, and if nothing
      # is found, a value found in the fallback locale will be used instead.
      def translate(key)
        read(key.to_s)
      end

      alias :t :translate

      # Clear the cache. Should be called after appending a new locale path
      # manually (in case lookups have already occurred.)
      #
      # When adding a locale path, it's best to use #append_locale_path, which
      # resets the cache automatically.
      def reset!
        @cache = nil
      end

      def inspect
        "<##{self.class} locale=#{self.locale}>"
      end

      def available_locales
        load_cache_if_needed
        @cache.keys.sort
      end

    private

      def read(key)
        load_cache_if_needed
        translated = read_from_hash(key, @cache[self.locale])
        translated ||= read_from_hash(key, @cache[@fallback_locale]) if self.locale != @fallback_locale
        translated
      end

      def read_from_hash(key, source_hash)
        key.split('.').inject(source_hash) { |hash, key|
          hash[key] unless hash.nil?
        }
      end

      # Load all files located in @locale_paths, merge them, and store the result
      # in @cache.
      def load_cache_if_needed
        return unless @cache.nil?
        hashes = load_hashes_for_paths(@locale_paths)
        @cache = Utils.deep_hash_merge(hashes)
      end

      def load_hashes_for_paths(paths)
        paths.collect { |path|
          if !File.exist?(path)
            fail "Path #{path} not found when loading locale files"
          end
          Dir[path + '**/*.yml'].map { |file_path|
            YAML.load_file(file_path)
          }
        }.flatten
      end

    end
  end
end
