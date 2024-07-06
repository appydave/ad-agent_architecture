# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      module Actions
        # Save workflow graph to database
        class SaveDatabase
          attr_reader :workflow_id

          def initialize(workflow)
            @workflow_hash = workflow.data
          end

          def save
            @workflow_id = nil
            # puts JSON.pretty_generate(@workflow_hash)
            DB.transaction do
              # puts "Saving Workflow: #{@workflow_hash[:name]}"
              # Save workflow
              workflow_record = Ad::AgentArchitecture::Database::Workflow.create(
                name: @workflow_hash[:name],
                description: @workflow_hash[:description]
              )

              @workflow_id = workflow_record.id

              # Saving attributes
              attribute_records = @workflow_hash[:attributes].map do |_name, attr|
                # puts "Saving Attribute: #{attr}"
                Ad::AgentArchitecture::Database::Attribute.create(
                  name: attr[:name],
                  type: attr[:type],
                  is_array: attr[:is_array],
                  description: attr[:description],
                  workflow: workflow_record
                )
              end

              attribute_map = attribute_records.to_h { |ar| [ar.name.to_sym, ar] }

              # Save prompts
              @workflow_hash[:prompts].each_value do |prompt|
                # puts "Saving Prompt: #{prompt}"
                Ad::AgentArchitecture::Database::Prompt.create(
                  name: prompt[:name],
                  path: prompt[:path],
                  content: prompt[:content],
                  description: prompt[:description],
                  workflow: workflow_record
                )
              end

              # Save settings
              @workflow_hash[:settings].each do |name, setting|
                puts "Saving Setting: #{setting}"
                Ad::AgentArchitecture::Database::Setting.create(
                  name: name.to_s,
                  value: setting[:value],
                  description: setting[:description],
                  workflow: workflow_record
                )
              end

              # Save sections and steps
              @workflow_hash[:sections].each do |section|
                # puts "Saving Section: #{section}"
                section_record = Ad::AgentArchitecture::Database::Section.create(
                  name: section[:name],
                  order: section[:order],
                  description: section[:description],
                  workflow: workflow_record
                )

                section[:steps].each do |step|
                  # puts "Saving Step: #{step}"
                  step_record = Ad::AgentArchitecture::Database::Step.create(
                    name: step[:name],
                    order: step[:order],
                    prompt: step[:prompt],
                    description: step[:description],
                    section: section_record
                  )

                  step[:input_attributes].each do |attr_name|
                    # puts "Saving Input Attribute for Step: #{attr_name}"
                    Ad::AgentArchitecture::Database::InputAttribute.create(
                      step: step_record,
                      attribute: attribute_map[attr_name.to_sym]
                    )
                  end

                  step[:output_attributes].each do |attr_name|
                    # puts "Saving Output Attribute for Step: #{attr_name}"
                    Ad::AgentArchitecture::Database::OutputAttribute.create(
                      step: step_record,
                      attribute: attribute_map[attr_name.to_sym]
                    )
                  end
                end
              end
            end
            @workflow_id
          rescue StandardError => e
            puts "An error occurred: #{e.message}"
            raise
          end
        end
      end
    end
  end
end
