# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the workflow DSL
      class WorkflowDsl
        attr_reader :workflow

        def initialize(name)
          @workflow = { name: name, sections: [], attributes: {}, prompts: {}, settings: {} }
          @current_section_order = 1
        end

        def settings(&block)
          dsl = SettingsDsl.new(@workflow)
          dsl.instance_eval(&block) if block_given?
          dsl
        end

        def attributes(&block)
          dsl = AttributeDsl.new(@workflow)
          dsl.instance_eval(&block) if block_given?
          dsl
        end

        def prompts(&block)
          dsl = PromptDsl.new(@workflow)
          dsl.instance_eval(&block) if block_given?
          dsl
        end

        def section(name, &block)
          dsl = SectionDsl.new(@workflow, name, @current_section_order)
          @current_section_order += 1
          dsl.instance_eval(&block) if block_given?
          dsl
        end
      end
    end
  end
end
