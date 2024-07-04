# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the workflow DSL
      class WorkflowDsl
        attr_reader :data

        def initialize(name)
          @data = { name: name, sections: [], attributes: {}, prompts: {}, settings: {} }
          @current_section_order = 1
        end

        def settings(&block)
          dsl = SettingsDsl.new(self)
          dsl.instance_eval(&block) if block_given?
          dsl
        end

        def attributes(&block)
          dsl = AttributeDsl.new(self)
          dsl.instance_eval(&block) if block_given?
          dsl
        end

        def prompts(&block)
          dsl = PromptDsl.new(self)
          dsl.instance_eval(&block) if block_given?
          dsl
        end

        def section(name, &block)
          dsl = SectionDsl.new(self, name, @current_section_order)
          @current_section_order += 1
          dsl.instance_eval(&block) if block_given?
          dsl
        end
      end
    end
  end
end
