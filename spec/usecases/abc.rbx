start_time = Time.now
dsl = Agent.create(:medium_article_writer) do
  description 'This workflow is used to transform a YouTube script into a professional and engaging Medium article.'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/youtube/script_writer')
    default_llm :gpt4o
  end

  prompts do
    prompt :review_script         , content: load_file("01-1-working-idea.txt")
    prompt :outline_script        , content: load_file("01-1-working-idea.txt")
    prompt :introduction          , content: load_file("01-1-working-idea.txt")
    prompt :title_subtitle        , content: load_file("01-1-working-idea.txt")
    prompt :expand_content        , content: load_file("01-1-working-idea.txt")
    prompt :headings_subheadings  , content: load_file("01-1-working-idea.txt")
    prompt :visuals_media         , content: load_file("01-1-working-idea.txt")
    prompt :links_references      , content: load_file("01-1-working-idea.txt")
    prompt :editing_proofreading  , content: load_file("01-1-working-idea.txt")
    prompt :formatting            , content: load_file("01-1-working-idea.txt")
    prompt :call_to_action        , content: load_file("01-1-working-idea.txt")
    prompt :author_bio            , content: load_file("01-1-working-idea.txt")
  end

  attributes do
    attribute :script, type: :string
    attribute :outline, type: :string
    attribute :introduction, type: :string
    attribute :title, type: :string
    attribute :subtitle, type: :string
    attribute :expanded_content, type: :string
    attribute :headings_subheadings, type: :array
    attribute :visuals, type: :array
    attribute :links_references, type: :array
    attribute :edited_article, type: :string
    attribute :formatted_article, type: :string
    attribute :call_to_action, type: :string
    attribute :author_bio, type: :string
  end

  section('Preparation') do
    step('Review Script') do
      input :script
      prompt :review_script
      output :outline
    end

    step('Outline Script') do
      input :outline
      prompt :outline_script
      output :outline
    end
  end

  section('Writing') do
    step('Introduction') do
      input :outline
      prompt :introduction
      output :introduction
    end

    step('Title and Subtitle') do
      input :outline
      prompt :title_subtitle
      output :title
      output :subtitle
    end

    step('Content Expansion') do
      input :outline
      prompt :expand_content
      output :expanded_content
    end

    step('Headings and Subheadings') do
      input :expanded_content
      prompt :headings_subheadings
      output :headings_subheadings
    end
  end

  section('Enhancement') do
    step('Visuals and Media') do
      input :headings_subheadings
      prompt :visuals_media
      output :visuals
    end

    step('Links and References') do
      input :expanded_content
      prompt :links_references
      output :links_references
    end
  end

  section('Finalization') do
    step('Editing and Proofreading') do
      input :expanded_content
      input :links_references
      prompt :editing_proofreading
      output :edited_article
    end

    step('Formatting') do
      input :edited_article
      prompt :formatting
      output :formatted_article
    end

    step('Call to Action') do
      input :formatted_article
      prompt :call_to_action
      output :call_to_action
    end

    step('Author Bio') do
      input :formatted_article
      prompt :author_bio
      output :author_bio
    end
  end
end

file1_local = '/Users/davidcruwys/dev/kgems/ad-agent_architecture/a1.json'
file1 = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/abc.json'
dsl
  .save
  .save_json(file1_local)
  .save_json(file1)

last_workflow = Ad::AgentArchitecture::Database::Workflow.order(Sequel.desc(:id)).first

data = Ad::AgentArchitecture::Report::AgentDataBuilder.new(last_workflow.id).build

# # puts JSON.pretty_generate(data)

file2_local = '/Users/davidcruwys/dev/kgems/ad-agent_architecture/a2.json'
file2 = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/abc.json'
File.write(file2_local, JSON.pretty_generate(data))
File.write(file2, JSON.pretty_generate(data))


# # Ad::AgentArchitecture::Report::WorkflowDetailReport.new.print(last_workflow)
# # Ad::AgentArchitecture::Report::WorkflowListReport.new.print
# # Ad::AgentArchitecture::Report::DslGenerator.new(dsl.workflow, clipboard: true, display: false).dsl_for_attributes

# # Print time taken in seconds
puts "Time taken: #{Time.now - start_time} seconds"
