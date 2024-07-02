# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the attributes of a workflow
      class AttributeDsl < ChildDsl
        def attribute(name, type:, is_array: false)
          workflow[:attributes][name] = { name: name, type: type, is_array: is_array }
        end
      end
    end
  end
end
