# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Dsl
      # Helper methods for accessing data in the workflow DSL
      module DataAccessors
        def settings
          data[:settings]
        end

        def sections
          data[:sections]
        end

        def get_setting(name)
          settings[name.to_sym] || settings[name.to_s]
        end

        def attributes
          data[:attributes]
        end

        def get_attribute(name)
          attributes[name.to_sym] || attributes[name.to_s]
        end

        def prompts
          data[:prompts]
        end

        def get_prompt(name)
          prompts[name.to_sym] || prompts[name.to_s]
        end

        def get_prompt_content(name)
          lookup = get_prompt(name)
          lookup ? lookup[:content] : nil
        end
      end
    end
  end
end
