start_time = Time.now

dsl = Agent.create(:youtube_script_booster) do
  description 'This workflow designs compelling YouTube video intros & outros to boost engagement and watch time.'
  
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/youtube/script_booster')
    default_llm :gpt4o
  end

  prompts do
    prompt :intro_hook_ideas_prompt                   , content: load_file("01-1-intro-hook-ideas.txt")
    prompt :intro_hooks_prompt                        , content: load_file("01-2-intro-hooks.txt")
    prompt :intro_episode_recap_analysis_prompt       , content: load_file("03-1-intro-recap-episode-content-analysis.txt")
    prompt :intro_episode_recap_script_prompt         , content: load_file("03-2-intro-recap-episode-script.txt")
    prompt :outro_bridge_content_analysis_prompt      , content: load_file("05-1-outro-bridge-content-analysis.txt")
    prompt :outro_bridge_script_prompt                , content: load_file("05-2-outro-bridge-script.txt")
  end

  attributes do
    attribute :audience                       , type: :string
    attribute :current_video_goal             , type: :string
    attribute :current_video_abridgement      , type: :string
    attribute :intro_scenario                 , type: :string
    attribute :intro_hook_idea1               , type: :string
    attribute :intro_hook_idea2               , type: :string
    attribute :intro_hook_idea3               , type: :string
    attribute :intro_hook_ideas               , type: :string
    attribute :next_video_goal                , type: :string
    attribute :next_video_abridgment          , type: :string # Not used
    attribute :last_video_abridgement         , type: :string
    attribute :last_goal                      , type: :string
    attribute :outro_bridge_content_analysis  , type: :string
    attribute :outro_bridge_script            , type: :string
    attribute :intro_episode_recap_analysis   , type: :string
    attribute :intro_episode_recap_script     , type: :string
  end

  section('Intro Hook') do
    step('Hook Ideas') do
      input :current_video_goal
      input :intro_scenario
      prompt :intro_hook_ideas_prompt
      output :intro_hook_ideas
    end

    step('Write Intro Hook') do
      input :intro_hook_idea1
      input :intro_hook_idea2
      input :intro_hook_idea3
      input :intro_scenario
      input :audience
      prompt :intro_hooks_prompt
      output :intro_hook
    end
  end

  section('Last Episode Recap Bridge') do
    step('Intro Recap Content Analysis') do
      input :last_video_abridgement
      input :current_video_goal
      prompt :intro_episode_recap_analysis_prompt
      output :intro_recap_content_analysis
    end

    step('Write Intro Recap Script') do
      input :current_video_goal
      input :intro_episode_recap_analysis
      prompt :intro_episode_recap_script_prompt
      output :intro_episode_recap_script
    end
  end

  section('Next Episode Outro Bridge') do
    step('Outro Content Analysis') do
      input :current_video_abridgement
      input :next_video_goal
      prompt :outro_bridge_content_analysis_prompt
      output :outro_bridge_content_analysis
    end

    step('Outro Booster Script') do
      input :next_video_goal
      input :outro_bridge_content_analysis
      prompt :outro_bridge_script_prompt
      output :outro_bridge_script
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/youtube-intro-outro-booster.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
