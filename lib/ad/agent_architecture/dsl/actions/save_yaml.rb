# frozen_string_literal: true

require 'yaml'

module Ad
  module AgentArchitecture
    module Dsl
      module Actions
        # Save workflow graph to YAML file
        class SaveYaml
          def initialize(workflow_hash)
            @workflow_hash = workflow_hash
          end

          def save(file_name)
            File.write(file_name, @workflow_hash.to_yaml)
          end
        end
      end
    end
  end
end
