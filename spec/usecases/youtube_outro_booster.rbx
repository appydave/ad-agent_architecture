start_time = Time.now

dsl = Agent.create(:youtube_outro_booster) do
  description 'This workflow designs compelling YouTube video endings to boost engagement and watch time.'
  
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/youtube/youtube_outro_booster')
    default_llm :gpt4o
  end

  prompts do
    prompt :content_analysis_prompt          , content: load_file("01-content-analysis.txt")
    prompt :outro_script_prompt              , content: load_file("02-outro-script.txt")
    prompt :outro_script_cue_points_prompt   , content: load_file("03-outro-script-cue-points.txt")
  end

  attributes do
    attribute :abridgement, type: :string
    attribute :next_video_goal, type: :string
    attribute :content_analysis, type: :string
    attribute :outro_script, type: :string
    attribute :outro_script_cue_points, type: :string
  end

  section('YouTube Outro Bridge') do
    step('Content Analysis') do
      input :abridgement
      input :next_video_goal
      prompt :content_analysis_prompt
      output :content_analysis
    end

    step('Write Outro Script') do
      input :next_video_goal
      input :content_analysis
      prompt :outro_script_prompt
      output :outro_script
    end

    step('Script + CUE Points') do
      input :outro_script
      prompt :outro_qa_prompt
      output :outro_script_cue_points
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/youtube-outro-booster.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
