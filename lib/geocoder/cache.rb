module Geocoder
  class Cache

    def initialize(store, prefix)
      @store = store
      @prefix = prefix
    end

    ##
    # Read from the Cache.
    #
    def [](url)
      interpret store[key_for(url)]
    end

    ##
    # Write to the Cache.
    #
    def []=(url, value)
      store[key_for(url)] = value
    end

    ##
    # Expire cache entry for given URL,
    # or pass <tt>:all</tt> to expire everything.
    #
    def expire(url)
      if url == :all
        urls.each{ |u| expire(u) }
      else
        self[url] = nil
      end
    end


    private # ----------------------------------------------------------------

    attr_reader :prefix, :store

    ##
    # Cache key for a given URL.
    #
    def key_for(url)
      [prefix, url].join
    end

    ##
    # Array of keys with the currently configured prefix
    # that have non-nil values.
    #
    def keys
      store.keys.select{ |k| k.match /^#{prefix}/ and interpret(store[k]) }
    end

    ##
    # Array of cached URLs.
    #
    def urls
      keys.map{ |k| k[/^#{prefix}(.*)/, 1] }
    end

    ##
    # Clean up value before returning. Namely, convert empty string to nil.
    # (Some key/value stores return empty string instead of nil.)
    #
    def interpret(value)
      value == "" ? nil : value
    end
  end
end
