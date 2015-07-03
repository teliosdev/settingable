# encoding: utf-8

require "forwardable"

module Settingable
  # A module containing the settings configuration.
  module Settings
    # The class methods for the Settings module.
    module ClassMethods
      extend Forwardable

      def_delegators :settings, :[], :[]=, :fetch,
                     :method_missing
      def_delegator :settings, :build, :configure

      # Returns an instance of the included module.  Repeated calls
      # return the same instance.
      #
      # @return [Settings]
      def settings
        @_settings ||= new
      end

      # @!method default_settings
      #   Retrieves the default settings.  If there are no defaults,
      #   it returns an empty hash.
      #
      #   @return [Hash]
      #
      # @!method default_settings(value)
      #   Sets the default settings.
      #
      #   @param value [Hash] The default settings.
      #   @return [void]
      def default_settings(value = nil)
        if value
          @_default_settings = value
        else
          @_default_settings || {}
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

    extend Forwardable
    def_delegators :@settings, :fetch

    # Initialize the settings.  Merges the given settings to the default
    # settings.
    #
    # @param settings [Hash] The initial settings.
    def initialize(settings = {})
      @settings = DeepMerge.deep_merge(self.class.default_settings, settings)
    end

    # Builds the settings construct.  It yields itself, and then returns
    # itself.
    #
    # @yield
    # @return [self]
    def build
      yield self
      self
    end

    # Sets a key to a value.
    #
    # @param key [Symbol, String] The key.
    # @param value [Object] The value.
    # @return [void]
    def []=(key, value)
      @settings[key.to_s.to_sym] = value
    end

    # Retrieves a key.  If it doesn't exist, it errors.
    #
    # @param key [Symbol, String] The key.
    # @return [Object]
    def [](key)
      @settings.fetch(key.to_s.to_sym)
    end

    # Method missing.  For set methods, it maps to the `:[]=` method; for
    # regular methods (i.e. not bang or ? methods), it maps to the `:[]`
    # method.
    #
    # @return [Object]
    def method_missing(method, *args, &block)
      return super if args.length > 1 || block_given? || method =~ /(\?|\!)\z/
      map_method(method, args)
    end

    private

    # Maps the methods.
    def map_method(method, args)
      if method =~ /\A(.*)\=\z/ && args.length == 1
        self[$+] = args[0]
      elsif args.length == 0
        self[method.to_s]
      else
        fail NameError, "Undefined method `#{method}' called on #{self}"
      end
    end
  end
end
