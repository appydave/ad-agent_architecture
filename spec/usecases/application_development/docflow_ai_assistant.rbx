start_time = Time.now

dsl = Agent.create(:docflow_ai_assistant) do
  description 'This workflow is designed to assist with code documentation, visualization, and generating useful documentation tools.'

  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/application_development/docflow_ai_assistant')
    default_llm :gpt4o
  end

  prompts do
    prompt :project_scope              , content: load_file("01-define-scope.txt")
    prompt :codebase_analysis          , content: load_file("02-analyze-codebase.txt")
    prompt :component_identification   , content: load_file("03-identify-components.txt")
    prompt :interaction_mapping        , content: load_file("04-map-interactions.txt")
    prompt :system_overview            , content: load_file("05-review-system-overview.txt")
    prompt :pattern_identification     , content: load_file("06-identify-patterns.txt")
    prompt :functionality_document     , content: load_file("07-document-functionality.txt")
    prompt :business_logic_analysis    , content: load_file("08-analyze-business-logic.txt")
    prompt :testing_patterns_analysis  , content: load_file("09-analyze-testing-patterns.txt")
    prompt :code_examples              , content: load_file("10-generate-code-examples.txt")
    prompt :logic_walkthrough          , content: load_file("11-walkthrough-key-logic.txt")
    prompt :visual_aids                , content: load_file("12-create-visual-aids.txt")
    prompt :user_story_generator       , content: load_file("13-user-story-generator.txt")
    prompt :table_designer             , content: load_file("14-table-designer.txt")
    prompt :code_example_generator     , content: load_file("15-code-example-generator.txt")
    prompt :class_diagram_generator    , content: load_file("16-class-diagram-generator.txt")
    prompt :algorithm_explanation      , content: load_file("17-algorithm-explanation-template.txt")
    prompt :test_case_documentation    , content: load_file("18-test-case-documentation-tool.txt")
    prompt :use_case_diagram_generator , content: load_file("19-use-case-diagram-generator.txt")
    prompt :data_flow_diagram_generator, content: load_file("20-data-flow-diagram-generator.txt")
  end

  attributes do
    attribute :project_overview           , type: :string
    attribute :defined_scope              , type: :string
    attribute :codebase_structure         , type: :string
    attribute :identified_components      , type: :string
    attribute :component_interactions     , type: :string
    attribute :system_overview            , type: :string
    attribute :identified_patterns        , type: :string
    attribute :documented_functionality   , type: :string
    attribute :documented_business_logic  , type: :string
    attribute :testing_patterns           , type: :string
    attribute :code_examples              , type: :string
    attribute :logic_walkthroughs         , type: :string
    attribute :erd                        , type: :string
    attribute :dfd                        , type: :string
    attribute :class_diagrams             , type: :string
    attribute :user_stories               , type: :string
    attribute :data_tables                , type: :string
    attribute :example_templates          , type: :string
    attribute :algorithm_templates        , type: :string
    attribute :test_case_docs             , type: :string
    attribute :use_case_diagrams          , type: :string
    attribute :data_flow_diagrams         , type: :string
  end

  section('Planning and Initialization') do
    description 'Set project objectives and analyze the existing codebase.'
    
    step('Define Scope') do
      input :project_overview
      prompt :project_scope
      output :defined_scope
    end

    step('Analyze Codebase') do
      input :defined_scope
      prompt :codebase_analysis
      output :codebase_structure
    end

    step('Identify Components') do
      input :codebase_structure
      prompt :component_identification
      output :identified_components
    end

    step('Map Interactions') do
      input :identified_components
      prompt :interaction_mapping
      output :component_interactions
    end

    step('Review System Overview') do
      input :component_interactions
      prompt :system_overview
      output :system_overview
    end
  end

  section('Identification and Analysis') do
    description 'Identify and analyze system patterns, functionality, business logic, and testing methodologies.'

    step('Identify Patterns') do
      input :system_overview
      prompt :pattern_identification
      output :identified_patterns
    end

    step('Document Functionality') do
      input :identified_patterns
      prompt :functionality_document
      output :documented_functionality
    end

    step('Analyze Business Logic') do
      input :documented_functionality
      prompt :business_logic_analysis
      output :documented_business_logic
    end

    step('Analyze Testing Patterns') do
      input :documented_business_logic
      prompt :testing_patterns_analysis
      output :testing_patterns
    end
  end

  section('Documentation and Visualization') do
    description 'Generate code examples, logic walkthroughs, and create visual aids.'

    step('Generate Code Examples') do
      input :documented_functionality
      prompt :code_examples
      output :code_examples
    end

    step('Walkthrough Key Logic') do
      input :code_examples
      prompt :logic_walkthrough
      output :logic_walkthroughs
    end

    step('Create Visual Aids') do
      input :system_overview
      prompt :visual_aids
      output :erd
      output :dfd
      output :class_diagrams
    end
  end

  section('Documentation Creation Tool') do
    description 'Generate user stories, tables, diagrams, and various templates for documentation.'

    step('User Story Generator') do
      input :code_examples
      input :documented_functionality
      prompt :user_story_generator
      output :user_stories
    end

    step('Table Designer') do
      input :system_overview
      prompt :table_designer
      output :data_tables
    end

    step('Code Example Generator') do
      input :documented_functionality
      prompt :code_example_generator
      output :example_templates
    end

    step('Class Diagram Generator') do
      input :component_interactions
      prompt :class_diagram_generator
      output :class_diagrams
    end

    step('Algorithm Explanation Template') do
      input :documented_business_logic
      prompt :algorithm_explanation
      output :algorithm_templates
    end

    step('Test Case Documentation Tool') do
      input :testing_patterns
      prompt :test_case_documentation
      output :test_case_docs
    end

    step('Use Case Diagram Generator') do
      input :identified_patterns
      prompt :use_case_diagram_generator
      output :use_case_diagrams
    end

    step('Data Flow Diagram Generator') do
      input :system_overview
      prompt :data_flow_diagram_generator
      output :data_flow_diagrams
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/docflow-ai-assistant.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
