# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # DSL for defining agent workflows
      class AgentWorkflowDsl
        def self.create(name:, &block)
          new(name).tap do |dsl|
            dsl.instance_eval(&block) if block_given?
            dsl.save
          end
        end

        def initialize(name)
          @workflow = { name: name, sections: [], attributes: {} }
          @current_section_order = 1
        end

        def attributes(&block)
          instance_eval(&block) if block_given?
        end

        def attribute(name, type:, is_array: false)
          @workflow[:attributes][name] = { name: name, type: type, is_array: is_array }
        end

        def section(name:, &block)
          @current_step_order = 1
          @current_section = { name: name, order: @current_section_order, steps: [] }
          @current_section_order += 1
          instance_eval(&block) if block_given?
          @workflow[:sections] << @current_section
        end

        def step(name:, &block)
          @current_step = { name: name, order: @current_step_order, input_attributes: [], output_attributes: [] }
          @current_step_order += 1
          instance_eval(&block) if block_given?
          @current_section[:steps] << @current_step
        end

        def input(attr_name, **_opts)
          @current_step[:input_attributes] << attr_name
        end

        def output(attr_name, **_opts)
          @current_step[:output_attributes] << attr_name
        end

        def prompt(prompt_text, **_opts)
          @current_step[:prompt] = prompt_text
        end

        def save
          DB.transaction do
            # Save workflow
            workflow_record = Ad::AgentArchitecture::Database::Workflow.create(name: @workflow[:name])

            # Save attributes
            attribute_records = @workflow[:attributes].map do |_name, attr|
              Ad::AgentArchitecture::Database::Attribute.create(
                name: attr[:name], type: attr[:type], is_array: attr[:is_array], workflow: workflow_record
              )
            end
            attribute_map = attribute_records.to_h { |ar| [ar.name.to_sym, ar] }

            # Save sections and steps
            @workflow[:sections].each do |section|
              section_record = Ad::AgentArchitecture::Database::Section.create(
                name: section[:name], order: section[:order], workflow: workflow_record
              )

              section[:steps].each do |step|
                step_record = Ad::AgentArchitecture::Database::Step.create(
                  name: step[:name], order: step[:order], prompt: step[:prompt], section: section_record
                )

                step[:input_attributes].each do |attr_name|
                  Ad::AgentArchitecture::Database::InputAttribute.create(
                    step: step_record, attribute: attribute_map[attr_name.to_sym]
                  )
                end

                step[:output_attributes].each do |attr_name|
                  Ad::AgentArchitecture::Database::OutputAttribute.create(
                    step: step_record, attribute: attribute_map[attr_name.to_sym]
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
