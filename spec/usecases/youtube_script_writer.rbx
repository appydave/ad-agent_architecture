start_time = Time.now

dsl = Agent.create(:youtube_script_writer) do
  description 'AppyDave This workflow is used to write a script for a YouTube video.'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/youtube/script_writer')
    default_llm :claude
  end

  prompts do
    prompt :working_idea          , content: load_file("01-1-working-idea.txt")
    prompt :basic_factsheet       , content: load_file("01-2-basic-factsheet.txt")
    prompt :video_ideas           , content: load_file("01-3-video-ideas.txt")
    prompt :expanded_factsheet    , content: load_file("01-4-expanded-factsheet.txt")
    prompt :meta_data             , content: load_file("01-5-meta-data.txt")
  end

  attributes do
    attribute :idea, type: :string
    attribute :ideas, type: :array
    attribute :selected_idea, type: :string
    attribute :basic_factsheet, type: :string
    attribute :video_ideas, type: :array
    attribute :video_idea, type: :string
    attribute :expanded_factsheet, type: :string
    attribute :meta_engaging_titles, type: :array
    attribute :meta_keywords, type: :array
    attribute :meta_topics, type: :array
    attribute :script, type: :string
  end

  section('Research and Development') do
    step('Basic Idea') do
      input :idea
      prompt :working_idea
      output :ideas
    end

    step('Select an Idea') do
      input :ideas
      # action 'Select the best idea from the list.'
      output :selected_idea
    end

    step('Basic Factsheet') do
      input :selected_idea
      prompt :basic_factsheet
      output :basic_factsheet
    end

    step('Video ideas') do
      input :idea
      input :basic_factsheet
      prompt :video_ideas
      output :video_ideas
      output :basic_factsheet
    end

    step('Select Video Idea') do
      input :video_ideas
      # action 'Select the best video idea from the list.'
      output :video_idea
    end

    step('Expanded Factsheet') do
      input :idea
      input :basic_factsheet
      input :video_idea
      prompt :expanded_factsheet
      output :expanded_factsheet
    end

    step('Video Meta Data') do
      input :idea
      input :video_idea
      input :expanded_factsheet
      prompt :meta_data
      output :meta_engaging_titles
      output :meta_keywords
      output :meta_topics
    end
  end

  section('Develop Script') do
    step('Write Script') do
      input :video_idea
      input :expanded_factsheet
      # action 'Write a script for the video.'
      output :script
    end
  end
end

file1_local = '/Users/davidcruwys/dev/kgems/ad-agent_architecture/a1.json'
file1 = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/youtube-script-writer.json'
dsl
  .save
  .save_json(file1_local)
  .save_json(file1)

last_workflow = Ad::AgentArchitecture::Database::Workflow.order(Sequel.desc(:id)).first

data = Ad::AgentArchitecture::Report::AgentDataBuilder.new(last_workflow.id).build
# # puts JSON.pretty_generate(data)

file2_local = '/Users/davidcruwys/dev/kgems/ad-agent_architecture/a2.json'
file2 = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/youtube-script-writer.json'
File.write(file2_local, JSON.pretty_generate(data))
File.write(file2, JSON.pretty_generate(data))


# # Ad::AgentArchitecture::Report::WorkflowDetailReport.new.print(last_workflow)
# # Ad::AgentArchitecture::Report::WorkflowListReport.new.print
# # Ad::AgentArchitecture::Report::DslGenerator.new(dsl.workflow, clipboard: true, display: false).dsl_for_attributes

# # Print time taken in seconds
puts "Time taken: #{Time.now - start_time} seconds"
