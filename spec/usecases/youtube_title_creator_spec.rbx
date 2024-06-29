dsl = Agent.create(name: 'YouTube Title Creator') do
  prompts do
    prompt :best_practice, path: 'youtube/title_creator/best_practice.md'
  end

  attributes do
    attribute :start_title, type: :string
    attribute :start_keyword, type: :string
    attribute :transcript, type: :string
    attribute :potential_titles, type: :array
    attribute :working_title, type: :string
  end

  section(name: 'Research') do
    step(name: 'Starting Context') do
      prompt :best_practice
    end

    step(name: 'Basic titles') do
      input :start_title
      input :start_keyword
      input :transcript
      prompt <<~TEXT
        Keyword: [start_keyword]
        Title: [start_title]

        Transcript:

        [start_transcript]
      TEXT
      output :potential_titles
    end

    step(name: 'Working Title') do
      input :potential_titles
      # action do
      #   heading 'Choose a working title from the potential titles.'
      #   ask 'Which title would you like to use?'
      # end
      output :working_title
    end
  end
end

dsl
  .save
  .save_json('workflow.json')
  .save_yaml('workflow.yaml')

workflow = Ad::AgentArchitecture::Database::Workflow.first(name: 'YouTube Title Creator')

Ad::AgentArchitecture::Report::WorkflowDetailReport.new.print(workflow)
Ad::AgentArchitecture::Report::WorkflowListReport.new.print
