# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the settings of a workflow
      class SettingsDsl < ChildDsl
        def method_missing(name, *args, **kwargs, &block)
          if args.length == 1 && block.nil?
            data[:settings][name] = { value: args.first, description: kwargs[:description] }
          else
            super
          end
        end

        def respond_to_missing?(_name, _include_private = false)
          true
        end
      end
    end
  end
end
