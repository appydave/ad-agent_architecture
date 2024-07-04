# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the settings of a workflow
      class SettingsDsl < ChildDsl
        def method_missing(name, *args, &block)
          if args.length == 1 && block.nil?
            data[:settings][name] = args.first
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
