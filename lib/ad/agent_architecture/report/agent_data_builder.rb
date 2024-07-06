# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Report
      # This class is responsible for building the agent data for export or visualization
      class AgentDataBuilder
        attr_reader :workflow_id, :data

        def initialize(workflow_id)
          @workflow_id = workflow_id
          @data = {}
        end

        def build
          fetch_workflow
          fetch_sections
          fetch_attributes
          fetch_prompts
          data
        end

        private

        def fetch_workflow
          workflow = Ad::AgentArchitecture::Database::Workflow.where(id: workflow_id).first

          @data[:name] = workflow.name
          @data[:title] = Cmdlet::Case::Title.new.call(workflow.name)
          @data[:description] = workflow.description
          @data[:settings] = fetch_settings(workflow)
        end

        def fetch_sections
          @data[:sections] = []
          sections = Ad::AgentArchitecture::Database::Section.where(workflow_id: workflow_id).order(:order)
          sections.each do |section|
            section_data = {
              name: section.name,
              title: Cmdlet::Case::Title.new.call(section.name),
              order: section.order,
              description: section.description,
              steps: fetch_steps(section.id)
            }
            @data[:sections] << section_data
          end
        end

        def fetch_steps(section_id)
          steps = Ad::AgentArchitecture::Database::Step.where(section_id: section_id).order(:order)
          steps.map do |step|
            {
              name: step.name,
              title: Cmdlet::Case::Title.new.call(step.name),
              order: step.order,
              description: step.description,
              prompt: step.prompt,
              input_attributes: fetch_input_attributes(step.id),
              output_attributes: fetch_output_attributes(step.id)
            }
          end
        end

        def fetch_input_attributes(step_id)
          Ad::AgentArchitecture::Database::InputAttribute.where(step_id: step_id).map do |input|
            attribute = input.attribute
            {
              name: attribute.name,
              type: attribute.type,
              is_array: attribute.is_array,
              description: attribute.description,
              title: Cmdlet::Case::Title.new.call(attribute.name)
            }
          end
        end

        def fetch_output_attributes(step_id)
          Ad::AgentArchitecture::Database::OutputAttribute.where(step_id: step_id).map do |output|
            attribute = output.attribute
            {
              name: attribute.name,
              type: attribute.type,
              is_array: attribute.is_array,
              description: attribute.description,
              title: Cmdlet::Case::Title.new.call(attribute.name)
            }
          end
        end

        def fetch_attributes
          @data[:attributes] = {}
          attributes = Ad::AgentArchitecture::Database::Attribute.where(workflow_id: workflow_id)
          attributes.each do |attr|
            @data[:attributes][attr.name.to_sym] = {
              name: attr.name,
              type: attr.type,
              is_array: attr.is_array,
              description: attr.description,
              title: Cmdlet::Case::Title.new.call(attr.name)
            }
          end
        end

        def fetch_prompts
          @data[:prompts] = {}
          prompts = Ad::AgentArchitecture::Database::Prompt.where(workflow_id: workflow_id)
          prompts.each do |prompt|
            @data[:prompts][prompt.name.to_sym] = {
              name: prompt.name,
              content: prompt.content,
              description: prompt.description,
              title: Cmdlet::Case::Title.new.call(prompt.name)
            }
          end
        end

        def fetch_settings(_workflow)
          result = {}
          settings = Ad::AgentArchitecture::Database::Setting.where(workflow_id: workflow_id)
          settings.each do |setting|
            result[setting.name.to_sym] = {
              value: setting.value,
              description: setting.description,
              title: Cmdlet::Case::Title.new.call(setting.name)
            }
          end
          result
        end
      end
    end
  end
end
