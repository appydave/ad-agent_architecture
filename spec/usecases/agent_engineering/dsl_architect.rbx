start_time = Time.now

dsl = Agent.create(:dsl_architect) do
  description 'This workflow guides GPT agents to design, transform, and architect Domain Specific Languages (DSLs) and their schemas or outputs.'
  
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/agent_engineering/dsl_architect')
    default_llm :gpt4o
  end



  # https://chatgpt.com/c/66f277c4-e47c-8002-b187-b46c2775edcc



  prompts do
    prompt :problem_definition       , content: load_file("01-problem-definition.txt")
    # prompt :dsl_guidelines           , content: load_file("02-dsl-guidelines.txt")
    prompt :dsl_structure            , content: load_file("03-propose-dsl-structure.txt")
    prompt :schema_design            , content: load_file("04-design-schema.txt")
    prompt :generate_sample_output   , content: load_file("05-generate-sample-output.txt")
    prompt :transform_dsl            , content: load_file("06-transform-dsl.txt")
    prompt :validate_output          , content: load_file("07-validate-output.txt")
  end

  attributes do
    attribute :problem, type: :string
    attribute :domain_requirements, type: :array
    attribute :domain_brief, type: :string
    attribute :dsl_rules, type: :string
    attribute :dsl_examples, type: :array
    attribute :dsl, type: :string
    attribute :schema_rules, type: :string
    attribute :schema_examples, type: :array
    attribute :schema, type: :string
    attribute :json_output, type: :string
    attribute :old_dsl, type: :string
    attribute :validation_report, type: :string
  end

  section('Language Design') do
    description "Define problem and create initial DSL structure"

    step('Define Problem') do
      input :problem
      input :domain_requirements
      prompt :problem_definition
      output :domain_brief
    end

    step('Configure DSL Guidelines') do
      input :dsl_rules
      input :dsl_examples
      # prompt :dsl_guidelines
    end

    step('Propose DSL Structure') do
      input :domain_brief
      input :dsl_rules
      input :dsl_examples
      prompt :dsl_structure
      output :dsl
    end
  end

  section('Schema Design and Output Generation') do
    description "Design schema for DSL and generate sample output"

    step('Design Schema') do
      input :dsl
      input :schema_rules
      input :schema_examples
      prompt :schema_design
      output :schema
    end

    step('Generate Sample Output') do
      input :dsl
      input :schema
      prompt :generate_sample_output
      output :json_output
    end
  end

  section('DSL Tools') do
    description "Transform DSL and validate outputs"

    step('Transform DSL') do
      input :old_dsl
      prompt :transform_dsl
      output :dsl
    end

    step('Validate Accuracy') do
      input :dsl
      input :schema
      input :json_output
      prompt :validate_output
      output :validation_report
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/dsl-architect.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
