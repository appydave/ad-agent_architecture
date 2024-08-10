dsl = Agent.create(:case_management) do
  description 'Law Practice Workflow: Case Management'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/youtube/script_writer')
    default_llm :gpt4o
  end

  prompts do
    prompt :conduct_initial_consultation  , content: load_file("01-1-working-idea.txt")
    prompt :collect_client_information    , content: load_file("01-2-basic-factsheet.txt")
    prompt :collect_evidence              , content: load_file("01-3-video-ideas.txt")
    prompt :conduct_legal_research        , content: load_file("01-4-expanded-factsheet.txt")
    prompt :draft_legal_documents         , content: load_file("01-5-meta-data.txt")
    prompt :file_documents_with_court     , content: load_file("01-1-working-idea.txt")
    prompt :update_client_on_case_status  , content: load_file("01-3-video-ideas.txt")
  end

  attributes do
    attribute :client_inquiry, type: :string
    attribute :consultation_notes, type: :string
    attribute :case_file, type: :string
    attribute :detailed_client_profile, type: :string
    attribute :compiled_evidence, type: :array
    attribute :case_details, type: :string
    attribute :research_findings, type: :string
    attribute :drafted_documents, type: :array
    attribute :filed_documents, type: :array
    attribute :case_status, type: :string
    attribute :case_review_notes, type: :string
    attribute :client_update, type: :string
  end

  section('Case Intake') do
    step('Initial Consultation') do
      input :client_inquiry
      prompt :conduct_initial_consultation
      output :consultation_notes
    end

    step('Open Case File') do
      input :consultation_notes
      output :case_file
    end

    step('Collect Client Information') do
      input :case_file
      prompt :collect_client_information
      output :detailed_client_profile
    end
  end

  section('Case Preparation') do
    step('Gather Evidence') do
      input :case_file
      prompt :collect_evidence
      output :compiled_evidence
    end

    step('Legal Research') do
      input :case_details
      prompt :conduct_legal_research
      output :research_findings
    end

    step('Draft Legal Documents') do
      input :case_file
      input :research_findings
      prompt :draft_legal_documents
      output :drafted_documents
    end
  end

  section('Case Progression') do
    step('File Documents') do
      input :drafted_documents
      prompt :file_documents_with_court
      output :filed_documents
    end

    step('Case Review') do
      input :filed_documents
      input :case_status
      # action :review_case_status_and_next_steps
      output :case_review_notes
    end

    step('Client Communication') do
      input :case_review_notes
      prompt :update_client_on_case_status
      output :client_update
    end
  end
end

file1_local = '/Users/davidcruwys/dev/kgems/ad-agent_architecture/a1.json'
file1 = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/a1.json'
dsl
  .save
  .save_json(file1_local)
  .save_json(file1)

  last_workflow = Ad::AgentArchitecture::Database::Workflow.order(Sequel.desc(:id)).first

data = Ad::AgentArchitecture::Report::AgentDataBuilder.new(last_workflow.id).build

# # puts JSON.pretty_generate(data)

File.write(file1_local, JSON.pretty_generate(data))
File.write(file1, JSON.pretty_generate(data))

