module Flex
  # never instantiate this class directly: it is automatically done by the scoped method
  class Scope < Vars

    class Error < StandardError; end

    require 'flex/scope/vars_methods'
    require 'flex/scope/query_methods'

    include VarsMethods
    include QueryMethods

    SCOPED_METHODS = VarsMethods.instance_methods + QueryMethods.instance_methods

    def inspect
      "#<#{self.class.name} #{self}>"
    end

    def respond_to?(meth, private=false)
      super || is_template?(meth) || is_scope?(meth)
    end

    def method_missing(meth, *args, &block)
      super unless respond_to?(meth)
      case
      when is_scope?(meth)
        deep_merge self[:context].send(meth, *args, &block)
      when is_template?(meth)
        self[:context].send(meth, deep_merge(args.first), &block)
      end
    end

  private

    def is_template?(name)
      self[:context].flex.respond_to?(:templates) && self[:context].flex.templates.has_key?(name.to_sym)
    end

    def is_scope?(name)
      self[:context].scope_methods.include?(name.to_sym)
    end

  end
end
