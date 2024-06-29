# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      module Actions
        # Save workflow graph to database
        class SaveDatabase
          def initialize(workflow_hash)
            @workflow_hash = workflow_hash
          end

          def save
            DB.transaction do
              # Save workflow
              workflow_record = Ad::AgentArchitecture::Database::Workflow.create(name: @workflow_hash[:name])

              # Save attributes
              attribute_records = @workflow_hash[:attributes].map do |_name, attr|
                Ad::AgentArchitecture::Database::Attribute.create(
                  name: attr[:name], type: attr[:type], is_array: attr[:is_array], workflow: workflow_record
                )
              end

              attribute_map = attribute_records.to_h { |ar| [ar.name.to_sym, ar] }

              # Save sections and steps
              @workflow_hash[:sections].each do |section|
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
end