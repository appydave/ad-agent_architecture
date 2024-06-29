# frozen_string_literal: true

require 'json'

module Ad
  module AgentArchitecture
    module Dsl
      module Actions
        # Save workflow graph to JSON file
        class SaveJson
          def initialize(workflow_hash)
            @workflow_hash = workflow_hash
          end

          def save(file_name)
            # Pretty JSON
            File.write(file_name, JSON.pretty_generate(@workflow_hash))
          end
        end
      end
    end
  end
end
