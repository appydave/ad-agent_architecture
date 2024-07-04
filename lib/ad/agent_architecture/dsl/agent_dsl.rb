# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the agent DSL
      class AgentDsl
        attr_reader :workflow

        def self.create(name, &block)
          new(name).tap do |dsl|
            dsl.instance_eval(&block) if block_given?
          end
        end

        def initialize(name)
          raise ArgumentError, 'Agent name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)

          @workflow = WorkflowDsl.new(name)
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

        def section(name, &block)
          raise ArgumentError, 'Section name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)

          @workflow.section(name, &block)
        end

        def save
          Ad::AgentArchitecture::Dsl::Actions::SaveDatabase.new(@workflow.data).save

          self
        end

        def save_json(file_name = nil)
          full_file_name = file_name || 'workflow.json'
          Ad::AgentArchitecture::Dsl::Actions::SaveJson.new(@workflow.data).save(full_file_name)

          self
        end

        def save_yaml(file_name = nil)
          full_file_name = file_name || 'workflow.yaml'
          Ad::AgentArchitecture::Dsl::Actions::SaveYaml.new(@workflow.data).save(full_file_name)

          self
        end
      end
    end
  end
end
