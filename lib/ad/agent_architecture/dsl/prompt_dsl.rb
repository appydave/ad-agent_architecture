# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the prompts of a workflow
      class PromptDsl
        def initialize(prompts)
          @prompts = prompts
        end

        def prompt(name, path: nil, content: nil)
          @prompts[name] = { name: name, path: path, content: content }
        end
      end
    end
  end
end
