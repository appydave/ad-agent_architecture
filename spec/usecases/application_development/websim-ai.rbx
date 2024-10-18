start_time = Time.now

dsl = Agent.create(:websim_ai) do
  description 'Generate user stories, tables, diagrams, and various templates for documentation.'

  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/application_development/websim_ai')
    default_llm :gpt4o
  end

  prompts do
      # source: https://www.youtube.com/watch?v=O0sHmghJHIk&t
      prompt :create_app_prompt                , content: load_file("01-create-game.txt")
  end

  attributes do
    attribute :user_inputs                  , type: :string
    attribute :expected_output_description  , type: :string
  end

  section('Requirements') do
    step('Requirement') do
      # Example: role playing game setting for which user wants to brainstorm possible characters to play
      input :user_inputs
      # list of characters that have such fields: name, background story, class, skills, character quirks, explanation how to roleplay that character to have most fun, full size character image.
      input :expected_output_description
      # source: https://www.youtube.com/watch?v=O0sHmghJHIk&t
      prompt :create_app_prompt
      output :create_app
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/websim-ai.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
