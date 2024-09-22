start_time = Time.now

dsl = Agent.create(:sleep_habit_selector) do
  description 'This workflow helps select and track a daily habit to improve sleep quality.'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/sleep/sleep_habit_selector')
    default_llm :gpt4o
  end

  prompts do
    prompt :analyze_sleep_patterns   , content: load_file("01-analyze-sleep-patterns.txt")
    prompt :identify_improvements    , content: load_file("02-identify-improvements.txt")
    prompt :propose_sleep_habits     , content: load_file("03-propose-sleep-habits.txt")
    prompt :evaluate_habit_impact    , content: load_file("04-evaluate-habit-impact.txt")
    prompt :select_optimal_habit     , content: load_file("05-select-optimal-habit.txt")
    prompt :implement_habit_tracking , content: load_file("06-implement-habit-tracking.txt")
    prompt :monitor_and_adjust       , content: load_file("07-monitor-and-adjust.txt")
  end

  attributes do
    attribute :sleep_data, type: :hash
    attribute :routine_data, type: :hash
    attribute :sleep_pattern_analysis, type: :hash
    attribute :improvement_opportunities, type: :hash
    attribute :proposed_sleep_habits, type: :array
    attribute :habit_impact_assessment, type: :hash
    attribute :selected_sleep_habit, type: :string
    attribute :habit_tracking_system, type: :hash
    attribute :progress_report, type: :hash
    attribute :updated_sleep_habit, type: :string
  end

  section('Sleep Analysis and Improvement') do
    step('Analyze Sleep Patterns') do
      input :sleep_data
      input :routine_data
      prompt :analyze_sleep_patterns
      output :sleep_pattern_analysis
    end

    step('Identify Improvements') do
      input :sleep_pattern_analysis
      prompt :identify_improvements
      output :improvement_opportunities
    end
  end

  section('Habit Proposal, Selection, and Implementation') do
    step('Propose Sleep Habits') do
      input :improvement_opportunities
      prompt :propose_sleep_habits
      output :proposed_sleep_habits
    end

    step('Evaluate Habit Impact') do
      input :proposed_sleep_habits
      input :sleep_data
      prompt :evaluate_habit_impact
      output :habit_impact_assessment
    end

    step('Select Optimal Habit') do
      input :habit_impact_assessment
      prompt :select_optimal_habit
      output :selected_sleep_habit
    end

    step('Implement Habit Tracking') do
      input :selected_sleep_habit
      prompt :implement_habit_tracking
      output :habit_tracking_system
    end
  end

  section('Monitoring and Adjustment') do
    step('Monitor and Adjust') do
      input :habit_tracking_system
      input :sleep_data
      prompt :monitor_and_adjust
      output :updated_sleep_habit
      output :progress_report
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/sleep-habit-selector.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
