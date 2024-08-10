start_time = Time.now

dsl = Agent.create(:agent_workflow_architect) do
  description 'This workflow will help build new agent workflows'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/agent_workflow_architect')
    default_llm :gpt4o
  end

  prompts do
    prompt :workflow_outline          , content: load_file("01-1-workflow-outline.txt")
    prompt :workflow_dsl              , content: load_file("01-2-workflow-dsl.txt")
  end

  attributes do
    attribute :workflow_idea, type: :string
    attribute :workflow_outline, type: :string
  end

  section('Develop') do
    step('Workflow Outline') do
      input :workflow_idea
      prompt :workflow_outline
      output :workflow_outline
    end

    step('Create Agent DSL') do
      input :workflow_outline
      prompt :workflow_dsl
      output :workflow_dsl
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/agent-workflow-architect.json'
dsl
  .save
  .save_json(file)

  puts "Time taken: #{Time.now - start_time} seconds"
