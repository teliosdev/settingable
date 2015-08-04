# encoding: utf-8

module Settingable
  # A hash that raises an error on an access that fails.
  class Hash < ::Hash
    # Initialize the hash.  If a value is passed, the values are set
    # on this hash.  Does not modify the value.
    #
    # @param body [Hash]
    # @see #convert
    def initialize(body = {})
      body.each do |key, value|
        self[key] = value
      end
    end

    alias_method :old_key?, :key?

    # Checks to determine if the given key is set in this hash.  It
    # first converts the key to a Symbol, then performs the check.
    #
    # @param key [String, Symbol, Object]
    # @return [Boolean]
    def key?(key)
      case key
      when String then super(key.intern)
      when Symbol then super(key)
      else             super(key.to_s.intern)
      end
    end

    alias_method :old_access, :[]
    # Accesses the hash.  It raises an error if it can't find the
    # key.  It attempts to convert the key into a Symbol.
    #
    # @param key [String, Symbol, Object] The key.
    # @return [Object] The value.
    # @raise KeyError If the key isn't mapped to a value.
    def [](key)
      case key
      when String then fetch(key.intern)
      when Symbol then fetch(key)
      else             fetch(key.to_s.intern)
      end
    end

    alias_method :old_set, :[]=
    # Used to set a key to a value.  The key is first converted to a
    # Symbol, and the value is coerced into a {Hash} if it is a
    # `::Hash`.
    #
    # @param key [String, Symbol, Object]
    # @param value [Hash, Object]
    # @return [void]
    # @see #convert
    def []=(key, value)
      case key
      when String then super(key.intern, convert(value))
      when Symbol then super(key, convert(value))
      else             super(key.to_s.intern, convert(value))
      end
    end

    # A blank object used as a canary for {#fetch}.
    #
    # @api private
    BLANK_OBJECT = Object.new
    private_constant :BLANK_OBJECT

    alias_method :old_fetch, :fetch
    # Performs a fetch.  If the key is in the hash, it returns its
    # value.  If the key is not in the hash, and a value was passed,
    # the value is returned.  If the key is not in the hash, and a
    # block was passed, it yields.  Otherwise, it raises KeyError.
    #
    # @param key [Object] The key.
    # @param value [Object] The default object.
    # @yield [key]
    # @return [Object]
    # @raise KeyError If the key isn't in the hash and no default
    #   was given.
    def fetch(key, value = BLANK_OBJECT)
      case
      when old_key?(key)         then old_access(key)
      when block_given?          then yield(key)
      when value != BLANK_OBJECT then value
      else
        fail KeyError, "Key not found: #{key.inspect}"
      end
    end

    # Converts this hash into a normal hash.  Since we recursively
    # converted every hash value into a {Settingable::Hash}, we have
    # to undo that for the new hash.
    #
    # @return [::Hash]
    def to_h
      out = {}
      each do |key, value|
        out[key] = convert(value, true)
      end

      out
    end

    private

    # Converts the value to a {Settingable::Hash}, if it is a regular
    # ruby hash.  Otherwise, it returns the value.
    #
    # @param value [Hash, Object]
    # @return [Settingable::Hash, Object]
    def convert(value, invert = false)
      if value.is_a?(::Hash)
        invert ? value.to_h : Settingable::Hash.new(value)
      else
        value
      end
    end
  end
end
