# file: lib/ad/agent_architecture/dsl/step_dsl.rb

# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the steps of a section
      class StepDsl < ChildDsl
        attr_reader :section
        attr_reader :step

        def initialize(workflow, section, name, order)
          super(workflow)
          @step = {
            name: name,
            order: order,
            prompt: '',
            input_attributes: [],
            output_attributes: []
          }

          @section = section
          @section[:steps] << @step
        end

        def input(name, **_opts)
          infer_attribute(name)
          @step[:input_attributes] << name
        end

        def output(name, **_opts)
          infer_attribute(name)
          @step[:output_attributes] << name
        end

        def prompt(prompt, **_opts)
          # lookup_prompt = workflow.get_prompt(prompt)
          @step[:prompt] = prompt
        end

        private

        def infer_attribute(name)
          AttributeDsl.new(workflow).infer_attribute(name)
        end
      end
    end
  end
end
