# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the prompts of a workflow
      class PromptDsl < ChildDsl
        def prompt(name, path: nil, content: nil)
          workflow[:prompts][name] = { name: name, content: content }
        end

        def prompt_file(file)
          prompt_path = workflow[:settings][:prompt_path]
          raise 'Prompt path not defined in settings' unless prompt_path

          full_path = File.join(prompt_path, file)
          File.read(full_path)
        end
      end
    end
  end
end
