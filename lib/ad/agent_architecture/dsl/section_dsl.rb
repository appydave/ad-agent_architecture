# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for creating a section in the workflow
      class SectionDsl
        def initialize(name, order, sections)
          @section = { name: name, order: order, steps: [] }
          @sections = sections
          @current_step_order = 1
          @sections << @section
        end

        def step(name:, &block)
          StepDsl.new(name, @current_step_order, @section[:steps]).instance_eval(&block)
          @current_step_order += 1
        end
      end
    end
  end
end
