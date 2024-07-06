# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # This class is responsible for defining the prompts of a workflow
      class PromptDsl < ChildDsl
        attr_reader :current_prompt

        def prompt(name, path: nil, content: nil, description: nil, &block)
          raise ArgumentError, 'Prompt name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)

          @current_prompt = { name: name, path: path, content: content, description: description }

          prompts[name] = current_prompt

          instance_eval(&block) if block_given?

          self
        end

        def description(description)
          current_prompt[:description] = description

          self
        end

        def content(content)
          current_prompt[:content] = content

          self
        end

        def load_file(file)
          prompt_path = settings[:prompt_path]
          raise 'Prompt path not defined in settings. Set "prompt_path" to the path where you are keping prompts' unless prompt_path

          full_path = File.join(prompt_path[:value], file)
          File.read(full_path)
        end
      end
    end
  end
end
