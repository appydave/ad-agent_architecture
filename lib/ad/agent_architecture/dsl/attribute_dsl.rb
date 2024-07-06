# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the attributes of a workflow
      class AttributeDsl < ChildDsl
        attr_reader :current_attribute

        def attribute(name, type: :string, is_array: false, description: nil, &block)
          raise ArgumentError, 'Attribute name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)

          @current_attribute = { name: name, type: type, is_array: is_array, description: description }

          attributes[name] = current_attribute

          instance_eval(&block) if block_given?

          self
        end

        def description(description)
          current_attribute[:description] = description

          self
        end

        def type(type)
          current_attribute[:type] = type

          self
        end

        def is_array(is_array)
          current_attribute[:is_array] = is_array

          self
        end
      end
    end
  end
end
