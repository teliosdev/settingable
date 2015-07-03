# encoding: utf-8

module Settingable
  # A module to handle the merging of a hash.
  module DeepMerge
    module_function

    # Merges the source into the destination.  This is non-destructive
    # to the destination.  If a block is given, it's called if both
    # the source and destination have a non-mergable value.  Both the
    # values must be a hash for it to be merged.  If it is a
    # non-mergable, and the either the destination doesn't have the
    # key, or no block was given, the default is to overwrite the
    # destination with the new value.
    #
    # @param (see .deep_merge!)
    # @return (see .deep_merge!)
    # @yield (see .deep_merge!)
    def deep_merge(destination, source, &block)
      deep_merge!(destination.dup, source, &block)
    end

    # Merges the source into the destination.  This is destructive to
    # the destination.  If a block is given, it's called if both the
    # source and destination have a non-mergable value.  Both the
    # values must be a hash in order for it to be merged.  If it is
    # a non-mergable value, and either the destination doesn't have
    # the key, or no block was given, the default is to overwrite the
    # destination with the new value.
    #
    # @param destination [Hash] The destination hash.
    # @param source [Hash] The source hash.
    # @yield [key, destination_value, source_value] Yields to
    #   determine the action that should be taken to merge the two.
    # @return [Hash] The destination.
    def deep_merge!(destination, source, &block)
      source.each do |key, value|
        dvalue = destination[key]
        destination[key] = case
                           when value.is_a?(Hash) && dvalue.is_a?(Hash)
                             deep_merge(dvalue, value, &block)
                           when block && destination.key?(key)
                             block.call(key, dvalue, value)
                           else
                             value
                           end
      end

      destination
    end
  end
end
