module RKS
  module Support
    module Concern
      def included(receiver)
        receiver.extend self::ClassMethods if const_defined?(:ClassMethods)
        receiver.send :include, self::InstanceMethods if const_defined?(:InstanceMethods)
      end
    end
  end
end
