start_time = Time.now

dsl = Agent.create(:klueless_dsl_creator) do
  description 'This workflow will create a Ruby-like DSL for modeling hierarchical structures, including validation and output generation.'
  
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/klueless/dsl_creator')
    default_llm :gpt4o
  end

  prompts do
    prompt :dsl_name_description  , content: load_file("01-1-configure-dsl-name-description.txt")
    prompt :dsl_creation          , content: load_file("01-2-create-dsl.txt")
    prompt :create_schema         , content: load_file("01-3-create-schema.txt")
    prompt :compare_dsl_to_schema , content: load_file("01-4-compare-dsl-to-schema.txt")
    prompt :generate_output       , content: load_file("01-5-generate-output.txt")
  end

  attributes do
    attribute :project_requirements , type: :string
    attribute :dsl_name             , type: :string
    attribute :dsl_description      , type: :string
    attribute :dsl           , type: :string
    attribute :dsl_schema           , type: :string
    attribute :dsl_json             , type: :string
    attribute :dsl_inconcistencies  , type: :string
  end

  section('Build DSL') do
    step('Configure Name') do
      input :dsl
      input :project_requirements
      input :schema_rules
      input :schema_examples
      input :json_rules
      input :json_examples
      prompt :dsl_name_description
      output :dsl_name
      output :dsl_description
    end
    step('Create Sample DSL') do
      input :dsl_name
      input :dsl_description
      prompt :dsl_creation
      output :dsl
    end
    step('Create DSL Schema') do
      input :dsl
      input :schema_rules
      input :schema_examples
      prompt :create_schema
      output :dsl_schema
    end
    step('Compare DSL to DSL Schema') do
      input :dsl
      input :dsl_schema
      input :schema_rules
      input :schema_examples
      prompt :compare_dsl_to_schema
      output :dsl_inconcistencies
    end

    step('Generate Output') do
      input :dsl
      input :dsl_schema
      input :json_rules
      input :json_examples
      prompt :generate_output
      output :dsl_json
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/klueless-dsl-creator.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"

