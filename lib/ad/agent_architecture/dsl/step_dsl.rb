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
          self
        end

        def output(name, **_opts)
          infer_attribute(name)
          @step[:output_attributes] << name
          self
        end

        def prompt(prompt, **_opts)
          lookup_prompt = get_prompt(prompt)
          @step[:prompt] = lookup_prompt || prompt
          self
        end

        private

        def infer_attribute(name)
          raise ArgumentError, 'Attribute name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)

          return if attributes.key?(name)

          # May want to add more sophisticated type inference here
          type = name.to_s.end_with?('s') ? 'array' : 'string'
          attributes[name] = { name: name, type: type, is_array: type == 'array' }
        end
      end
    end
  end
end
