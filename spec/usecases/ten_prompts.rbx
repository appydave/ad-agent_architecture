start_time = Time.now

dsl = Agent.create(:ten_prompts) do
  description 'This workflow provides simple access to 10 prompts sourced from a YouTube channel.'
  # https://www.youtube.com/watch?v=lckRVyMzbBU
  # https://chatgpt.com/c/66f80cb7-4814-8002-a425-7ea452eadfed
  
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/youtube/ten_prompts')
    default_llm :gpt4o
  end

  prompts do
    prompt :newsletter_breakdown_prompt           , content: load_file("01-1-newsletter-breakdown.txt")
    prompt :newsletter_breakdown_followup_prompt  , content: load_file("01-2-newsletter-breakdown.txt")
    prompt :product_description_prompt       , content: load_file("02-product-description.txt")
    prompt :faq_creation_prompt              , content: load_file("03-faq-creation.txt")
    prompt :vsl_script_outline_prompt        , content: load_file("04-vsl-script-outline.txt")
    prompt :viral_title_generation_prompt    , content: load_file("05-viral-title-generation.txt")
    prompt :shorts_script_writer_prompt      , content: load_file("06-shorts-script-writer.txt")
    prompt :icp_offer_creation_prompt        , content: load_file("07-icp-offer-creation.txt")
    prompt :topical_map_generator_prompt     , content: load_file("08-topical-map-generator.txt")
    prompt :humanize_text_prompt             , content: load_file("09-humanize-text.txt")
    prompt :content_rewrite_prompt           , content: load_file("10-content-rewrite.txt")
    prompt :chat_summarizer_prompt           , content: load_file("50-chat-summarizer.txt")
  end
  
  attributes do
    attribute :newsletter_topic, type: :string
    attribute :newsletter_type_of_content
    attribute :newsletter_industry, type: :string
    attribute :newsletter_example, type: :string
    attribute :product_image, type: :image
    attribute :product_name, type: :string
    attribute :product_type, type: :string
    attribute :product_target_demographic, type: :string
    attribute :faq_title, type: :string
    attribute :vsl_product_service_name, type: :string
    attribute :vsl_target_audience, type: :string
    attribute :vsl_describe_ideal_customer, type: :string
    attribute :vsl_key_problems_solved, type: :string
    attribute :vsl_usp, type: :string
    attribute :vsl_main_benefits, type: :string
    attribute :vsl_cta, type: :string
    attribute :vsl_price_or_range, type: :string
    attribute :vsl_regs_or_compliance_issues, type: :string
    attribute :vsl_opening_hook_elements, type: :string
    attribute :vsl_pain_points_presentation, type: :string
    attribute :vsl_emphasize_consequences, type: :string
    attribute :vsl_solution_introduction, type: :string
    attribute :vsl_main_benefits_presentation, type: :string
    attribute :vsl_testimonials_or_case_studies, type: :string
    attribute :vsl_objections_handling, type: :string
    attribute :vsl_offer_presentation_structure, type: :string
    attribute :vsl_compelling_cta_crafting, type: :string
    attribute :vsl_guarantees_or_risk_reduction, type: :string
    attribute :vsl_summary_and_cta_reinforcement, type: :string
    attribute :vsl_desired_tone, type: :string
    attribute :vsl_desired_length, type: :string
    attribute :vsl_specific_elements_techniques, type: :string
    attribute :viral_topic, type: :string
    attribute :shorts_topic, type: :string
    attribute :icp_data, type: :string
    attribute :topical_data, type: :string
    attribute :content_to_humanize, type: :string
    attribute :content_to_rewrite, type: :string
  end

  section('Utilities') do
    step('Chat Summarizer') do
      prompt :chat_summarizer_prompt
    end
  end

  section('Content Identification and Extraction') do
    step('Newsletter Breakdown') do
      input :newsletter_topic
      input :newsletter_type_of_content
      input :newsletter_industry
      input :newsletter_example
      prompt :newsletter_breakdown_prompt
      output :newsletter_breakdown
    end

    step('Newsletter Breakdown - Followup') do
      input :newsletter_brandcompany
      input :newsletter_readinglevel
      prompt :newsletter_breakdown_followup_prompt
      output :newsletter_breakdown
    end

    step('Product Description') do
      input :product_image
      input :product_name
      input :product_type
      input :product_target_demographic
      prompt :product_description_prompt
      output :product_description
    end

    step('FAQ Creation') do
      input :faq_title
      prompt :faq_creation_prompt
      output :faq
    end

    step('VSL Script Outline') do
      input :vsl_product_service_name
      input :vsl_target_audience
      input :vsl_describe_ideal_customer
      input :vsl_key_problems_solved
      input :vsl_usp
      input :vsl_main_benefits
      input :vsl_cta
      input :vsl_price_or_range
      input :vsl_regs_or_compliance_issues
      input :vsl_opening_hook_elements
      input :vsl_pain_points_presentation
      input :vsl_emphasize_consequences
      input :vsl_solution_introduction
      input :vsl_main_benefits_presentation
      input :vsl_testimonials_or_case_studies
      input :vsl_objections_handling
      input :vsl_offer_presentation_structure
      input :vsl_compelling_cta_crafting
      input :vsl_guarantees_or_risk_reduction
      input :vsl_summary_and_cta_reinforcement
      input :vsl_desired_tone
      input :vsl_desired_length
      input :vsl_specific_elements_techniques
      prompt :vsl_script_outline_prompt
      output :vsl
    end
  end

  section('Content Creation and Optimization') do
    step('Viral Title Generation') do
      input :viral_topic
      prompt :viral_title_generation_prompt
      output :viral_title_suggestions
    end

    step('Shorts Script Writing') do
      input :shorts_topic
      prompt :shorts_script_writer_prompt
      output :shorts_script
    end

    step('ICP and Offer Creation') do
      input :icp_data
      prompt :icp_offer_creation_prompt
      output :icp_profile
      output :offer_strategy
    end

    step('Topical Map Generation') do
      input :topical_data
      prompt :topical_map_generator_prompt
      output :topical_map
    end
  end

  section('Content Refinement and Simplification') do
    step('Humanize Text') do
      input :content_to_humanize
      prompt :humanize_text_prompt
      output :humanized_text
    end

    step('Content Rewrite') do
      input :content_to_rewrite
      prompt :content_rewrite_prompt
      output :simplified_content
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/ten-prompts.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
