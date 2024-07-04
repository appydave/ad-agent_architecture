# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the attributes of a workflow
      class AttributeDsl < ChildDsl
        def attribute(name, type:, is_array: false)
          raise ArgumentError, 'Attribute name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)

          attributes[name] = { name: name, type: type, is_array: is_array }
        end

        def infer_attribute(name)
          raise ArgumentError, 'Attribute name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)

          return if attributes.key?(name)

          # May want to add more sophisticated type inference here
          type = name.to_s.end_with?('s') ? 'array' : 'string'
          attributes[name] = { name: name, type: type, is_array: type == 'array' }
        end
      end
    end
  end
end
