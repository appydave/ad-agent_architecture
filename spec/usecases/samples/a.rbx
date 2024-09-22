# http://localhost:5010/gpt-workflows/x/seo-for-legal-compliance
# 
dsl = Agent.create(:seo_for_legal_compliance) do
  description 'This workflow is for an SEO agency specializing in content marketing for lawyers focused on statutory compliance.'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/seo/legal_compliance')
    default_llm :gpt4o
  end

  prompts do
    prompt :identify_topics      , content: load_file("01-identify-topics.txt")
    prompt :research_keywords    , content: load_file("02-research-keywords.txt")
    prompt :draft_outlines       , content: load_file("03-draft-outlines.txt")
    prompt :generate_content     , content: load_file("04-generate-content.txt")
    prompt :review_accuracy      , content: load_file("05-review-accuracy.txt")
    prompt :optimize_content     , content: load_file("06-optimize-content.txt")
    prompt :publish_content      , content: load_file("07-publish-content.txt")
  end

  attributes do
    attribute :current_trends, type: :array
    attribute :legal_documents, type: :array
    attribute :compliance_topics, type: :array
    attribute :search_data, type: :array
    attribute :trending_keywords, type: :array
    attribute :content_outlines, type: :array
    attribute :draft_content, type: :string
    attribute :verified_content, type: :string
    attribute :seo_metrics, type: :hash
    attribute :optimized_content, type: :string
    attribute :publishing_tools, type: :array
    attribute :performance_data, type: :hash
  end

  section('Research and Planning') do
    step('Identify Topics') do
      input :current_trends
      input :legal_documents
      prompt :identify_topics
      output :compliance_topics
      output :abc
    end

    step('Research Keywords') do
      input :compliance_topics
      input :search_data
      prompt :research_keywords
      output :trending_keywords
    end

    step('Draft Outlines') do
      input :compliance_topics
      input :trending_keywords
      prompt :draft_outlines
      output :content_outlines
    end
  end

  section('Content Creation') do
    step('Generate Content') do
      input :content_outlines
      input :trending_keywords
      prompt :generate_content
      output :draft_content
    end

    step('Review Accuracy') do
      input :draft_content
      input :legal_documents
      prompt :review_accuracy
      output :verified_content
    end
  end

  section('Optimization and Publishing') do
    step('Optimize Content') do
      input :verified_content
      input :seo_metrics
      prompt :optimize_content
      output :optimized_content
    end

    step('Publish Content') do
      input :optimized_content
      input :publishing_tools
      prompt :publish_content
      output :published_content
      output :performance_data
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/seo-for-legal-compliance.json'
dsl
  .save
  .save_json(file)
