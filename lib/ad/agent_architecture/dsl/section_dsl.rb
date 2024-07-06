# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for creating a section in the workflow
      class SectionDsl < ChildDsl
        def initialize(workflow, name, order, description: nil)
          super(workflow)

          @section = { name: name, order: order, description: description, steps: [] }
          sections << @section
          @current_step_order = 1
        end

        def description(description)
          @section[:description] = description

          self
        end

        def step(name, description: nil, &block)
          raise ArgumentError, 'Step name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)

          StepDsl.new(workflow, @section, name, @current_step_order, description: description).instance_eval(&block)
          @current_step_order += 1

          self
        end
      end
    end
  end
end
