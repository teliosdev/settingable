# encoding: utf-8

require "forwardable"

module Settingable
  # A module containing the settings configuration.
  module Settings
    # The class methods for the Settings module.
    module ClassMethods
      extend Forwardable

      def_delegators :instance, :[], :[]=, :fetch,
                     :method_missing
      def_delegator :instance, :build, :configure

      # Returns an instance of the included module.  Repeated calls
      # return the same instance.
      #
      # @return [Settings]
      def instance
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
    def_delegators :@settings, :fetch, :[], :[]=, :key?

    # Initialize the settings.  Merges the given settings to the default
    # settings.
    #
    # @param settings [Hash] The initial settings.
    def initialize(settings = {})
      @settings = Settingable::Hash.new(merged_settings(settings))
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

    # Method missing.  For set methods, it maps to the `:[]=` method; for
    # regular methods (i.e. not bang or ? methods), it maps to the `:[]`
    # method.
    #
    # @return [Object]
    def method_missing(method, *args, &block)
      return super if args.length > 1 || block_given? || method =~ /(\?|\!)\z/
      map_method(method, args)
    end

    # A hook method for ruby.  This should not be called directly.  It
    # lets ruby know that we respond to certain methods.
    #
    # @param method [Symbol] The method to check.
    # @return [Boolean]
    def responds_to_missing?(method, _include_all = false)
      !(method =~ /(\?|\!)\z/)
    end

    private

    # Merges the given settings with the class defaults.  Performs a
    # deep merge.
    #
    # @param provided [Hash]
    # @return [Hash]
    def merged_settings(provided)
      DeepMerge.deep_merge(self.class.default_settings, provided)
    end

    # Maps the methods.  If the method is a setter, i.e. ends in `=`,
    # it sets the value.  If arguments are provided to a non-setter
    # method, it raises a NameError.
    #
    # @param method [Symbol]
    # @param args [Array<Object>]
    # @return [Object]
    # @raise NameError If more than 1 argument is provided to a
    #   setter, or arguments are provided to a non-setter method.
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
