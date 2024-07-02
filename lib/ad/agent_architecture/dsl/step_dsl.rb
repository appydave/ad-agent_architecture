# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the steps of a section
      class StepDsl
        def initialize(_workflow, section, name, order)
          @step = {
            name: name,
            order: order,
            prompt: '',
            input_attributes: [],
            output_attributes: []
          }

          section[:steps] << @step
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
