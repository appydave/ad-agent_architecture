# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the agent DSL
      class AgentDsl
        attr_reader :workflow

        def self.create(name:, &block)
          new(name).tap do |dsl|
            dsl.instance_eval(&block) if block_given?
          end
        end

        def initialize(name)
          @workflow = WorkflowDsl.new(name)
        end

        def attributes(&block)
          @workflow.attributes(&block)
        end

        def prompts(&block)
          @workflow.prompts(&block)
        end

        def section(name:, &block)
          @workflow.section(name: name, &block)
        end

        def save
          Ad::AgentArchitecture::Dsl::Actions::SaveDatabase.new(@workflow.workflow).save

          self
        end

        def save_json(file_name = nil)
          full_file_name = file_name || 'workflow.json'
          Ad::AgentArchitecture::Dsl::Actions::SaveJson.new(@workflow.workflow).save(full_file_name)

          self
        end

        def save_yaml(file_name = nil)
          full_file_name = file_name || 'workflow.yaml'
          Ad::AgentArchitecture::Dsl::Actions::SaveYaml.new(@workflow.workflow).save(full_file_name)

          self
        end
      end
    end
  end
end
