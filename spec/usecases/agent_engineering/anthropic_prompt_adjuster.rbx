start_time = Time.now

dsl = Agent.create(:anthropic_prompt_adjuster) do
  description 'This workflow refines and reformats an Anthropic-generated prompt to meet specific formatting and stylistic preferences.'
  
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/agent_engineering/anthropic_prompt_adjuster')
    default_llm :gpt4o
  end

  prompts do
    prompt :reformat_prompt          , content: load_file("01-reformat-prompt.txt")
    prompt :clean_up_prompt          , content: load_file("02-clean-up-prompt.txt")
  end

  attributes do
    attribute :anthropic_prompt, type: :string
    attribute :updated_prompt, type: :string
    attribute :clean_prompt, type: :string
  end

  section('Style and Structure Adjustment') do
    step('Reformat Prompt') do
      description "Take in Anthropic-generated prompt"
      input :anthropic_prompt
      prompt :reformat_prompt
      output :updated_prompt
    end

    step 'Clean Up Prompt' do
      description "Fix common issues with Anthropic prompts"

      input :updated_prompt
      prompt :clean_up_prompt
      output :clean_prompt
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/anthropic-prompt-adjuster.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
