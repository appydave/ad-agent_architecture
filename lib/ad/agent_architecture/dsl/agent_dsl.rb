# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the agent DSL
      class AgentDsl
        attr_reader :workflow
        attr_accessor :workflow_id

        def self.create(name, description: nil, &block)
          new(name, description: description).tap do |dsl|
            dsl.instance_eval(&block) if block_given?
          end
        end

        def description(description)
          @workflow.description(description)
        end

        def initialize(name, description: nil)
          raise ArgumentError, 'Agent name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)

          @workflow = WorkflowDsl.new(name, description: description)
        end

        def settings(&block)
          @workflow.settings(&block)
        end

        def attributes(&block)
          @workflow.attributes(&block)
        end

        def prompts(&block)
          @workflow.prompts(&block)
        end

        def section(name, description: nil, &block)
          raise ArgumentError, 'Section name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)

          @workflow.section(name, description: description, &block)
        end

        def save
          id = Ad::AgentArchitecture::Dsl::Actions::SaveDatabase.new(@workflow).save
          @workflow_id = id

          self
        end

        def save_json(file_name = nil)
          full_file_name = file_name || 'workflow.json'
          raise ArgumentError, 'Workflow needs to be saved, befor you can save JSON' unless workflow_id

          data = Ad::AgentArchitecture::Report::AgentDataBuilder.new(workflow_id).build

          Ad::AgentArchitecture::Dsl::Actions::SaveJson.new(data).save(full_file_name)

          self
        end

        def save_yaml(file_name = nil)
          full_file_name = file_name || 'workflow.yaml'
          raise ArgumentError, 'Workflow needs to be saved, befor you can save YAML' unless workflow_id

          data = Ad::AgentArchitecture::Report::AgentDataBuilder.new(workflow_id).build

          Ad::AgentArchitecture::Dsl::Actions::SaveYaml.new(data).save(full_file_name)

          self
        end
      end
    end
  end
end
