# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This is the base class for all child DSLs
      class ChildDsl
        attr_reader :workflow

        def initialize(workflow)
          @workflow = workflow
        end
      end
    end
  end
end
