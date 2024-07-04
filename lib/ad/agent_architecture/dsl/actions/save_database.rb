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
            puts JSON.pretty_generate(@workflow_hash)
            DB.transaction do
              # puts "Saving Workflow: #{@workflow_hash[:name]}"
              # Save workflow
              workflow_record = Ad::AgentArchitecture::Database::Workflow.create(name: @workflow_hash[:name])

              # Saving attributes
              attribute_records = @workflow_hash[:attributes].map do |_name, attr|
                # puts "Saving Attribute: #{attr}"
                Ad::AgentArchitecture::Database::Attribute.create(
                  name: attr[:name], type: attr[:type], is_array: attr[:is_array], workflow: workflow_record
                )
              end

              attribute_map = attribute_records.to_h { |ar| [ar.name.to_sym, ar] }

              # Save prompts
              @workflow_hash[:prompts].each_value do |prompt|
                # puts "Saving Prompt: #{prompt}"
                Ad::AgentArchitecture::Database::Prompt.create(
                  name: prompt[:name], path: prompt[:path], content: prompt[:content], workflow: workflow_record
                )
              end

              # Save sections and steps
              @workflow_hash[:sections].each do |section|
                # puts "Saving Section: #{section}"
                section_record = Ad::AgentArchitecture::Database::Section.create(
                  name: section[:name], order: section[:order], workflow: workflow_record
                )

                section[:steps].each do |step|
                  # puts "Saving Step: #{step}"
                  step_record = Ad::AgentArchitecture::Database::Step.create(
                    name: step[:name], order: step[:order], prompt: step[:prompt], section: section_record
                  )

                  step[:input_attributes].each do |attr_name|
                    # puts "Saving Input Attribute for Step: #{attr_name}"
                    Ad::AgentArchitecture::Database::InputAttribute.create(
                      step: step_record, attribute: attribute_map[attr_name.to_sym]
                    )
                  end

                  step[:output_attributes].each do |attr_name|
                    # puts "Saving Output Attribute for Step: #{attr_name}"
                    Ad::AgentArchitecture::Database::OutputAttribute.create(
                      step: step_record, attribute: attribute_map[attr_name.to_sym]
                    )
                  end
                end
              end
            end
          rescue StandardError
            puts "An error occurred: #{e.message}"
            raise
          end
        end
      end
    end
  end
end
