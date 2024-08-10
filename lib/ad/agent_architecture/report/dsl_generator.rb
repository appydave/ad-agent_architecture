# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Report
      # Generate DSL for an Agent Architecture workflow based on the workflow hash
      class DslGenerator
        include KLog::Logging

        attr_reader :display
        attr_reader :clipboard

        def initialize(workflow, display: true, clipboard: false)
          @workflow_hash = workflow if workflow.is_a?(Hash)
          # REFACTOR: There is no property workflow in the class Ad::AgentArchitecture::Dsl::WorkflowDsl
          @workflow_hash = workflow.workflow if workflow.is_a?(Ad::AgentArchitecture::Dsl::WorkflowDsl)

          @display = display
          @clipboard = clipboard
        end

        def dsl_for_settings
          settings_dsl = build_settings_dsl
          render(settings_dsl)
          settings_dsl
        end

        def dsl_for_attributes
          attributes_dsl = build_attributes_dsl
          render(attributes_dsl)
          attributes_dsl
        end

        def dsl_for_prompts
          prompts_dsl = build_prompts_dsl
          render(prompts_dsl)
          prompts_dsl
        end

        def dsl_for_sections
          sections_dsl = build_sections_dsl
          render(sections_dsl)
          sections_dsl
        end

        def dsl_for_workflow
          workflow_dsl = build_workflow_dsl
          render(workflow_dsl)
          workflow_dsl
        end

        private

        def build_settings_dsl
          settings_dsl = "settings do\n"
          @workflow_hash[:settings].each do |name, value|
            settings_dsl += "  #{name} #{value.inspect}\n"
          end

          settings_dsl += 'end'
          settings_dsl
        end

        def build_attributes_dsl
          attributes_dsl = "attributes do\n"
          @workflow_hash[:attributes].each do |name, details|
            attributes_dsl += "  attribute :#{name}, type: :#{details[:type]}"
            attributes_dsl += ", is_array: #{details[:is_array]}" if details[:is_array]
            attributes_dsl += "\n"
          end
          attributes_dsl += 'end'
          attributes_dsl
        end

        def build_prompts_dsl
          prompts_dsl = "prompts do\n"
          @workflow_hash[:prompts].each do |name, details|
            prompts_dsl += "  prompt :#{name}, content: #{details[:content].inspect}\n"
          end
          prompts_dsl += 'end'
          prompts_dsl
        end

        def build_sections_dsl
          sections_dsl = ''
          @workflow_hash[:sections].each do |section|
            sections_dsl += "section('#{section[:name]}') do\n"
            section[:steps].each do |step|
              sections_dsl += "  step('#{step[:name]}') do\n"
              step[:input_attributes].each { |attr| sections_dsl += "    input :#{attr}\n" }
              step[:output_attributes].each { |attr| sections_dsl += "    output :#{attr}\n" }
              sections_dsl += "    prompt :#{step[:prompt]}\n" if step[:prompt]
              sections_dsl += "  end\n"
            end
            sections_dsl += "end\n"
          end
          sections_dsl
        end

        def build_workflow_dsl
          workflow_dsl = "dsl = Agent.create('#{@workflow_hash[:name]}') do\n"
          workflow_dsl += build_settings_dsl
          workflow_dsl += "\n\n"
          workflow_dsl += build_prompts_dsl
          workflow_dsl += "\n\n"
          workflow_dsl += build_attributes_dsl
          workflow_dsl += "\n\n"
          workflow_dsl += build_sections_dsl
          workflow_dsl += "\nend"
          workflow_dsl
        end

        def render(dsl_code)
          puts dsl_code if display
          IO.popen('pbcopy', 'w') { |f| f << dsl_code } if clipboard
        end
      end
    end
  end
end
