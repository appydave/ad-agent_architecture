start_time = Time.now

dsl = Agent.create(:keywords_topic_clusters_and_intent) do
  description 'This workflow facilitates collaboration between GPT agents to analyze data, identify high-impact keywords, and organize them into topic clusters for optimizing brand positioning and search intent.'

  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/growth_hackers/keywords_topic_clusters_and_intent')
    default_llm :gpt4o
  end

  prompts do
    prompt :client_goals               , content: load_file("01-1-client-goals.txt")
    prompt :market_data                , content: load_file("01-2-market-data.txt")
    prompt :high_impact_keywords       , content: load_file("02-1-identify-keywords.txt")
    prompt :keyword_clustering         , content: load_file("02-2-group-keywords.txt")
    prompt :topical_authority_analysis , content: load_file("03-1-identify-authority.txt")
  end

  attributes do
    attribute :client_info             , type: :string
    attribute :client_goals            , type: :string
    attribute :external_data_sources   , type: :array
    attribute :market_trends           , type: :array
    attribute :high_impact_keywords    , type: :array
    attribute :keyword_clusters        , type: :array
    attribute :topical_authority       , type: :string
  end

  section('Define Goals and Data Sources') do
    description "Collect client goals and analyze market trends."

    step('Collect Client Goals') do
      input :client_info
      prompt :client_goals
      output :client_goals
    end

    step('Collect Market Data') do
      input :external_data_sources
      prompt :market_data
      output :market_trends
    end
  end

  section('Keyword Analysis and Clustering') do
    description "Identify high-impact keywords and organize them into topic clusters."

    step('Identify Keywords') do
      input :client_goals
      input :market_trends
      prompt :high_impact_keywords
      output :high_impact_keywords
    end

    step('Group Keywords') do
      input :high_impact_keywords
      prompt :keyword_clustering
      output :keyword_clusters
    end
  end

  section('Establish Topical Authority') do
    description "Analyze topical authority for identified keyword clusters."

    step('Identify Authority') do
      input :keyword_clusters
      prompt :topical_authority_analysis
      output :topical_authority
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/keywords-topic-clusters-and-intent.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
