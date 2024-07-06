# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the workflow DSL
      class WorkflowDsl
        include DataAccessors

        attr_reader :data

        def initialize(name, description: nil)
          @data = { name: name, description: description, sections: [], attributes: {}, prompts: {}, settings: {} }
          @current_section_order = 1
        end

        def description(description)
          @data[:description] = description
          self
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

        def section(name, description: nil, &block)
          dsl = SectionDsl.new(self, name, @current_section_order, description: description)
          @current_section_order += 1
          dsl.instance_eval(&block) if block_given?
          dsl
        end
      end
    end
  end
end
