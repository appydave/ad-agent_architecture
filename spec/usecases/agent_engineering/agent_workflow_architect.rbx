start_time = Time.now

dsl = Agent.create(:agent_workflow_architect) do
  description 'This workflow will help build new agent workflows'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/agent_workflow_architect')
    default_llm :gpt4o
  end

  prompts do
    prompt :workflow_idea_prompt             , content: load_file("1-1-workflow-idea.md")
    prompt :workflow_objective_prompt        , content: load_file("1-2-workflow-objective.md")
    prompt :list_steps_prompt                , content: load_file("1-3-list-steps.md")
    prompt :group_steps_phases_prompt        , content: load_file("1-4-group-steps-phases.md")
    prompt :workflow_name_ideas_prompt       , content: load_file("1-5-workflow-name-ideas.md") 
    prompt :specification_prompt             , content: load_file("2-1-specification.md")
    prompt :generate_dsl_prompt              , content: load_file("2-2-agent-dsl.md")
  end

  attributes do
    attribute :workflow_idea          , type: :string
    attribute :workflow_goal          , type: :string
    attribute :workflow_concept       , type: :string
    attribute :workflow_objective     , type: :string
    attribute :step_list              , type: :string
    attribute :step_list_organized    , type: :string
    attribute :specification          , type: :string
    attribute :workflow_name_ideas    , type: :string
    attribute :workflow_name          , type: :string
    attribute :dsl                    , type: :string
  end

  # I need to add description attributes
  section('Agent Workflow Design') do
    step('Workflow Idea') do
      description 'What is the idea for the new agent workflow?'
      input :workflow_idea
      prompt :workflow_idea_prompt
      output :workflow_goal
      output :workflow_concept
    end

    step('Workflow Objective') do
      description 'Develop the Workflow Objective'
      input :workflow_goal
      input :workflow_concept
      prompt :workflow_objective_prompt
      output :workflow_objective
    end

    step('List Steps') do
      description 'Identify all possible workflow steps'
      input :workflow_objective
      prompt :list_steps_prompt
      output :steps_list
    end

    step('Organize Steps') do # Group Steps into Phases
      input :workflow_objective
      input :step_list
      prompt :group_steps_phases_prompt
      output :step_list_organized
    end

    step('Workflow Name Ideas') do # Suggest a list of  Workflow Names
      input :workflow_objective
      input :step_list_organized
      prompt :workflow_name_ideas_prompt
      output :workflow_name_ideas
    end
  end

  section('Create Agent as Code') do
    step('Specification' ) do # Build workflow steps specification and represent in a table
      input :workflow_name
      input :step_list_organized
      prompt :specification_prompt
      output :specification
      output :workflow_name_ideas
    end

    step('Generate DSL') do # Generate Agent Workflow DSL
      input :workflow_name
      input :step_list_organized
      input :specification
      prompt :generate_dsl_prompt
      output :dsl
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/agent-workflow-architect.json'
dsl
  .save
  .save_json(file)

  puts "Time taken: #{Time.now - start_time} seconds"
