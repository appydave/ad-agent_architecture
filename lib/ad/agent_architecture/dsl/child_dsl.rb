# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This is the base class for all child DSLs
      class ChildDsl
        include DataAccessors
        attr_reader :workflow

        def initialize(workflow_dsl)
          @workflow = workflow_dsl
        end

        def data
          @workflow.data
        end
      end
    end
  end
end
