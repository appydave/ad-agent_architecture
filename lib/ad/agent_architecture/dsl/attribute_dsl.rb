# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the attributes of a workflow
      class AttributeDsl
        def initialize(attributes)
          @attributes = attributes
        end

        def attribute(name, type:, is_array: false)
          @attributes[name] = { name: name, type: type, is_array: is_array }
        end
      end
    end
  end
end
