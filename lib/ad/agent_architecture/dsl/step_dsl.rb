# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the steps of a section
      class StepDsl
        def initialize(name, order, steps)
          @step = { name: name, order: order, input_attributes: [], output_attributes: [], prompt: '' }
          @steps = steps
          @steps << @step
        end

        def input(attr_name, **_opts)
          @step[:input_attributes] << attr_name
        end

        def output(attr_name, **_opts)
          @step[:output_attributes] << attr_name
        end

        def prompt(prompt_text, **_opts)
          @step[:prompt] = prompt_text
        end
      end
    end
  end
end
