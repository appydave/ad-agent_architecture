dsl = Agent.create(name: 'YouTube Script Writer') do
  settings do
    # Path is relatevie to this file
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/youtube/script_writer')
  end

  prompts do
    prompt :working_idea, content: prompt_file("01-1-working-idea.txt")
    prompt :basic_factsheet, content: prompt_file("01-2-basic-factsheet.txt")
    prompt :video_ideas, content: prompt_file("01-3-video-ideas.txt")
    prompt :expanded_factsheet, content: prompt_file("01-4-expanded-factsheet.txt")
    prompt :meta_data, content: prompt_file("01-5-meta-data.txt")
  end

  attributes do
    attribute :idea, type: :string
    attribute :ideas, type: :array
    attribute :basic_factsheet, type: :string
    attribute :video_ideas, type: :array
    attribute :video_idea, type: :string
    attribute :expanded_factsheet, type: :string
    attribute :meta_engaging_titles, type: :array
    attribute :meta_keywords, type: :array
    attribute :meta_topics, type: :array
    attribute :script, type: :string
  end

  section(name: 'Research') do
    step(name: 'Basic Idea') do
      input :idea
      prompt :working_idea
      output :ideas
    end

    step(name: 'Basic Factsheet') do
      input :idea
      prompt :basic_factsheete
      output :basic_factsheet
    end

    step(name: 'Video ideas') do
      input :idea
      input :basic_factsheet
      prompt :video_ideas
      output :video_ideas
      output :basic_factsheet
    end

    step(name: 'Select Video Idea') do
      input :video_ideas
      # action 'Select the best video idea from the list.'
      output :video_idea
    end

    step(name: 'Expanded Factsheet') do
      input :idea
      input :basic_factsheet
      input :video_idea
      prompt :expanded_factsheet
      output :expanded_factsheet
    end

    step(name: 'Video Meta Data') do
      input :idea
      input :video_idea
      input :expanded_factsheet
      prompt :meta_data
      output :meta_engaging_titles
      output :meta_keywords
      output :meta_topics
    end
  end

  section(name: 'Develop Script') do
    step(name: 'Write Script') do
      input :video_idea
      input :expanded_factsheet
      # action 'Write a script for the video.'
      output :script
    end
  end
end

dsl
  .save
  .save_json('/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/youtube-script-writer.json')
  
workflow = Ad::AgentArchitecture::Database::Workflow.first(name: 'YouTube Script Writer')

Ad::AgentArchitecture::Report::WorkflowDetailReport.new.print(workflow)
Ad::AgentArchitecture::Report::WorkflowListReport.new.print

# Prompts need to support file read operation
# Fix the auto attribute create
# Include a report_attribute method or DSL under the tool namespace
# Visual graph of the workflow
# Horizontal
# Clicking on sections will show the steps in that section
# Clicking on attributes will show all attributes in the workflow
# Clicking on prompts will show all prompts in the workflow
# Clicking on dashboard will show visual hierarchy of the workflow
# Need a runs button
# Add support for project plan
# VCode Editor: https://chatgpt.com/c/e09e1367-db5e-4786-b362-db35805b1e20
