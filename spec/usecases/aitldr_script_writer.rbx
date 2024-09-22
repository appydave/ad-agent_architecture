start_time = Time.now

dsl = Agent.create(:aitldr_script_writer) do
  description 'Create YouTube scripts for AITLDR'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/aitldr_script_writer')
    default_llm :gpt4o
  end

  prompts do
    prompt :video_basic_factsheet, content: load_file("1-1-video-basic-factsheet.md")
    prompt :perplexity_expansion, content: load_file("1-2-expand-with-perplexity.md")
    prompt :consolidated_factsheet, content: load_file("1-3-consolidated-factsheet.md")
    prompt :project_details, content: load_file("1-4-project-details.md")
    prompt :factsheet_for_video_type, content: load_file("1-5-factsheet-for-video-type.md")
  end

  attributes do
    attribute :topic, type: :string
    attribute :topic_description, type: :string
    attribute :basic_factsheet, type: :string
    attribute :expanded_factsheet, type: :string
    attribute :consolidated_factsheet, type: :string
    attribute :video_factsheet, type: :string
    attribute :ideas_topic, type: :string
    attribute :ideas_video_type, type: :string
    attribute :ideas_project_name, type: :string
    attribute :ideas_project_title, type: :string
    attribute :detailed_topic, type: :string
    attribute :video_type, type: :string
    attribute :project_name, type: :string
    attribute :project_title, type: :string
  end
  # - How Pika Labs Simplifies Video Creation

  section('Video Research') do
    step('Basic Factsheet') do
      input :topic
      input :topic_description
      prompt :video_basic_factsheet
      output :basic_factsheet
    end

    step('Perplexity Expansion') do
      input :topic
      input :basic_factsheet
      prompt :perplexity_expansion
      output :expanded_factsheet
    end

    step('Consolidated Factsheet') do
      input :topic
      input :topic_description
      input :basic_factsheet
      input :expanded_factsheet
      prompt :consolidated_factsheet
      output :consolidated_factsheet
    end

    step('Project Details') do
      input :topic
      input :consolidated_factsheet
      prompt :project_details
      output :ideas_topic
      output :ideas_video_type
      output :ideas_project_name
      output :ideas_project_title
    end

    step('Select Ideas to Focus On') do #, type: :use_selection
      input :ideas_topic
      input :ideas_video_type
      input :ideas_project_name
      input :ideas_project_title
      output :video_topic
      output :video_type
      output :project_name
      output :project_title
    end

    step('Factsheet for Video Type') do
      input :video_topic
      input :video_type
      input :consolidated_factsheet
      prompt :factsheet_for_video_type
      output :video_factsheet
    end
  end

  section('Script Writing') do
    step('Write Script') do
      input :video_topic
      input :video_type
      input :project_title
      input :video_factsheet
      output :script
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/aitldr-script-writer.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
