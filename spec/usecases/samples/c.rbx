start_time = Time.now

dsl = Agent.create(:brandprint_design_insights) do
  description 'This workflow generates tailored print design recommendations using client data and industry trends.'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/brandprint/design_insights')
    default_llm :gpt4o
  end

  prompts do
    prompt :gather_guidelines      , content: load_file("01-gather-brand-guidelines.txt")
    prompt :analyze_orders         , content: load_file("02-analyze-past-orders.txt")
    prompt :identify_preferences   , content: load_file("03-identify-preferences.txt")
    prompt :review_trends          , content: load_file("04-review-trends.txt")
    prompt :generate_suggestions   , content: load_file("05-generate-suggestions.txt")
    prompt :recommend_designs      , content: load_file("06-recommend-designs.txt")
    prompt :optimize_feedback      , content: load_file("07-optimize-feedback.txt")
  end

  attributes do
    attribute :client_id, type: :integer
    attribute :brand_guidelines, type: :string
    attribute :order_history, type: :array
    attribute :design_preferences, type: :array
    attribute :trend_data, type: :array
    attribute :design_suggestions, type: :array
    attribute :recommended_fonts, type: :string
    attribute :recommended_layouts, type: :string
    attribute :recommended_colors, type: :string
    attribute :client_feedback, type: :string
    attribute :optimized_design_suggestions, type: :array
  end

  section('Client Data and Trend Analysis') do
    step('Gather Brand Guidelines') do
      input :client_id
      input :brand_guidelines
      prompt :gather_guidelines
      output :brand_guidelines
    end

    step('Analyze Past Orders') do
      input :client_id
      prompt :analyze_orders
      output :order_history
    end

    step('Identify Design Preferences') do
      input :client_id
      input :order_history
      prompt :identify_preferences
      output :design_preferences
    end

    step('Review Industry Trends') do
      input :design_preferences
      prompt :review_trends
      output :trend_data
    end
  end

  section('Design Suggestions and Optimization') do
    step('Generate Design Suggestions') do
      input :brand_guidelines
      input :design_preferences
      input :trend_data
      prompt :generate_suggestions
      output :design_suggestions
    end

    step('Recommend Fonts, Layouts, Colors') do
      input :design_suggestions
      input :trend_data
      prompt :recommend_designs
      output :recommended_fonts
      output :recommended_layouts
      output :recommended_colors
    end

    step('Optimize Based on Feedback') do
      input :client_feedback
      input :recommended_fonts
      input :recommended_layouts
      input :recommended_colors
      prompt :optimize_feedback
      output :optimized_design_suggestions
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/brandprint-design-insights.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
