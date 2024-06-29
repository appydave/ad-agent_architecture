# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the workflow DSL
      class WorkflowDsl
        attr_reader :workflow

        def initialize(name)
          @workflow = { name: name, sections: [], attributes: {}, prompts: {} }
          @current_section_order = 1
        end

        def attributes(&block)
          dsl = AttributeDsl.new(@workflow[:attributes])
          dsl.instance_eval(&block) if block_given?
        end

        def prompts(&block)
          dsl = PromptDsl.new(@workflow[:prompts])
          dsl.instance_eval(&block) if block_given?
        end

        def section(name:, &block)
          dsl = SectionDsl.new(name, @current_section_order, @workflow[:sections])
          dsl.instance_eval(&block) if block_given?
          @current_section_order += 1
        end
      end
    end
  end
end
