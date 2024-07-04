# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for creating a section in the workflow
      class SectionDsl < ChildDsl
        def initialize(workflow, name, order)
          super(workflow)

          @section = { name: name, order: order, steps: [] }
          sections << @section
          @current_step_order = 1
        end

        def step(name, &block)
          raise ArgumentError, 'Step name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)

          StepDsl.new(workflow, @section, name, @current_step_order).instance_eval(&block)
          @current_step_order += 1
        end
      end
    end
  end
end
