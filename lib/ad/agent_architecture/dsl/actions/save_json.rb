# frozen_string_literal: true

require 'json'

module Ad
  module AgentArchitecture
    module Dsl
      module Actions
        # Save workflow graph to JSON file
        class SaveJson
          def initialize(hash)
            @hash = hash
          end

          def save(file_name)
            File.write(file_name, JSON.pretty_generate(@hash))
          end
        end
      end
    end
  end
end
