dsl = Agent.create(:youtube_launch_optimizer) do
  description 'This workflow optimizes video launch by analyzing, preparing, and generating content for various platforms.'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/youtube/launch_optimizer')
    default_llm :gpt4o
  end


  # I need the project_code and folder in place
  # I need the video list updator
  # I need the video list selector
  # I need a transcript to image style list -> image style -> To B-ROLL generator


  prompts do
    prompt :short_title_prompt                , content: load_file("1-1-short-title.txt")
    prompt :video_summary_prompt              , content: load_file("1-1-summarize-video.txt")
    prompt :video_abridgement_prompt          , content: load_file("1-2-1-abridge-video.txt")
    prompt :abridgement_descrepencies_prompt  , content: load_file("1-3-abridge-video-descrepencies.txt")
    prompt :intro_outro_seperation_prompt     , content: load_file("1-4-seperate-intro-outro.txt")
    prompt :identify_chapters_prompt          , content: load_file("2-1-identify-chapters.txt")
    prompt :refine_chapters_prompt            , content: load_file("2-2-refine-chapters.txt")
    prompt :create_chapters_prompt            , content: load_file("2-3-create-chapters.txt")
    prompt :transcript_design_style_prompt    , content: load_file("3-1-transcript-design-style.txt") 
    prompt :intro_outro_design_ideas_prompt   , content: load_file("3-2-intro-outro-design-ideas.txt")
    prompt :editor_brief_prompt               , content: load_file("3-3-editor-brief.txt")
    prompt :transcript_design_ideas_prompt    , content: load_file("3-4-transcript-design-ideas.txt")
    prompt :analyze_content_essence_prompt    , content: load_file("4-1-analyze-content-essence.txt")
    prompt :analyze_audience_engagement_prompt, content: load_file("4-2-analyze-audience-engagement.txt")
    prompt :analyze_cta_competitors_prompt    , content: load_file("4-3-analyze-cta-competitors.txt")
    prompt :title_generation_prompt           , content: load_file("5-1-generate-title.txt")
    prompt :thumbnail_text_prompt             , content: load_file("5-2-generate-thumbnail-text.txt")
    prompt :thumbnail_text_csv_prompt         , content: load_file("5-3-generate-thumbnail-text-csv.txt")
    prompt :thumbnail_visual_elements_prompt  , content: load_file("5-4-thumbnail-visual-elements.txt")
    prompt :yt_simple_description_prompt      , content: load_file("6-1-yt-simple-description.txt")
    prompt :yt_description_prompt             , content: load_file("6-2-yt-write-description.txt")
    prompt :yt_format_description_prompt      , content: load_file("6-3-yt-format-description.txt")
    prompt :yt_description_custom_gpt_prompt  , content: load_file("6-4-yt-description-custom-gpt.txt")
    prompt :yt_pinned_comment_prompt          , content: load_file("6-5-yt-pinned-comment.txt") 
    prompt :yt_metadata_prompt                , content: load_file("6-6-yt-meta-data.txt")
    prompt :tweet_prompt                      , content: load_file("7-1-create-tweet.txt")
    prompt :facebook_post_prompt              , content: load_file("7-2-create-fb-post.txt")
    prompt :linkedin_post_prompt              , content: load_file("7-3-create-linkedin-post.txt")
    prompt :shorts_context_prompt             , content: load_file("8-1-create-shorts-context.txt")
    prompt :shorts_title_prompt               , content: load_file("8-2-create-shorts-title.txt")
    prompt :shorts_description_prompt         , content: load_file("8-3-create-shorts-description.txt")

    prompt :outcome_notes_prompt              , content: load_file("99-1-outcome-notes.txt")
    prompt :outcome_social_prompt              , content: load_file("99-2-outcome-social")
    prompt :outcome_thumbnail_prompt              , content: load_file("99-3-outcome-thumbnail")
  end

  attributes do
    attribute :gpt_links, type: :string
    attribute :project_code, type: :string
    attribute :project_folder, type: :string
    attribute :short_title, type: :string
    attribute :transcript, type: :string
    attribute :intro, type: :string
    attribute :outro, type: :string
    attribute :video_editor_instructions, type: :string
    attribute :intro_outro_design_ideas, type: :string
    attribute :design_style, type: :string
    attribute :design_ideas, type: :string
    attribute :editor_brief, type: :string
    attribute :srt, type: :string
    attribute :summary, type: :string
    attribute :abridgement, type: :string
    attribute :abridgement_descrepencies, type: :string
    attribute :analyze_content_essence, type: :string
    attribute :analyze_audience_engagement, type: :string
    attribute :analyze_cta_competitors, type: :string
    attribute :video_title, type: :string
    attribute :video_url, type: :string
    attribute :video_topic_theme, type: :string
    attribute :video_related_links, type: :array
    attribute :video_keywords, type: :array
    attribute :video_description, type: :string
    attribute :video_simple_description, type: :string
    attribute :video_description_custom_gpt, type: :string
    attribute :video_pinned_comment, type: :string
    attribute :video_metadata, type: :string
    attribute :key_takeaways, type: :string
    attribute :content_highlights
    attribute :identify_chapters, type: :string
    attribute :refine_chapters, type: :string
    attribute :chapters, type: :string
    attribute :fold_cta, type: :string
    attribute :primary_cta, type: :string
    attribute :affiliate_cta, type: :array
    attribute :brand_info, type: :string
    attribute :title_ideas, type: :array
    attribute :thumbnail_text, type: :string
    attribute :thumbnail_text_csv, type: :string
    attribute :thumbnail_visual_elements, type: :string
    attribute :tweet_content, type: :string
    attribute :facebook_post, type: :string
    attribute :linkedin_post, type: :string
    attribute :shorts_context, type: :string
    attribute :shorts_title, type: :string
    attribute :shorts_description, type: :string
    attribute :outcome_notes, type: :string
  end

  section 'Video Preparation' do
    step 'Configure' do
      input :gpt_links
      input :project_code
      input :project_folder
      input :short_title
      input :video_title
      input :video_url
      input :video_related_links
      input :video_keywords
      input :brand_info
      input :fold_cta
      input :primary_cta
      input :affiliate_cta
      input :chapters
      input :transcript
      input :abridgement
      input :summary
      input :intro
      input :outro
      prompt :short_title_prompt
      output :short_title
    end

    step 'Script Summary' do
      input :transcript
      prompt :video_summary_prompt
      output :summary
    end

    step 'Script Abridgement' do
      input :summary
      input :transcript
      prompt :video_abridgement_prompt
      output :abridgement
    end

    step 'Abridge QA' do
      input :transcript
      input :abridgement
      prompt :abridgement_descrepencies_prompt
      output :abridgement_descrepencies
    end

    step 'Intro/Outro Seperation' do
      input :transcript
      prompt :intro_outro_seperation_prompt
      output :intro
      output :outro
    end

    step 'Outcome Notes' do
      input :gpt_links
      input :short_title
      input :short_title
      input :transcript
      input :intro
      input :outro
      input :video_editor_instructions
      input :intro_outro_design_ideas
      input :design_style
      input :design_ideas
      input :editor_brief
      input :srt
      input :summary
      input :abridgement
      input :abridgement_descrepencies
      input :analyze_content_essence
      input :analyze_audience_engagement
      input :analyze_cta_competitors
      input :video_title
      input :video_url
      input :video_topic_theme
      input :video_related_links
      input :video_keywords
      input :video_description
      input :video_description_custom_gpt
      input :video_pinned_comment
      input :video_metadata
      input :content_highlights
      input :identify_chapters
      input :refine_chapters
      input :chapters
      input :fold_cta
      input :primary_cta
      input :affiliate_cta
      input :brand_info
      input :title_ideas
      input :thumbnail_text
      input :thumbnail_text_csv
      input :thumbnail_visual_elements
      input :tweet_content
      input :facebook_post
      input :linkedin_post
      input :shorts_title
      input :shorts_description
      input :outcome_notes
      prompt :outcome_notes_prompt
      output :outcome_notes
    end
  end


  section 'Build Chapters' do
    step 'Find Chapters' do
      input :transcript
      input :abridgement
      prompt :identify_chapters_prompt
      output :identify_chapters
    end

    step 'Refine Chapters' do
      input :identify_chapters
      input :refine_chapters
      prompt :refine_chapters_prompt
      output :chapters
    end

    step 'Create Chapters' do
      input :chapters
      input :srt
      prompt :create_chapters_prompt
      output :chapters
    end
  end

  section 'B-Roll Suggestions' do
    step 'Design Style List' do
      input :transcript
      prompt :transcript_design_style_prompt
      output :design_style
    end

    step 'Intro/Outro B-Roll' do
      input :intro
      input :outro
      input :design_style
      prompt :intro_outro_design_ideas_prompt
      output :intro_outro_design_ideas
    end

    step 'Brief for Video Editor' do
      input :video_editor_instructions
      input :intro_outro_design_ideas
      input :chapters
      prompt :editor_brief_prompt
      output :editor_brief
    end

    step 'Transcript Design Ideas' do
      input :transcript
      input :design_style
      prompt :transcript_design_ideas_prompt
      output :design_ideas
    end

    step 'Outcome Notes' do
      input :gpt_links
      input :short_title
      input :transcript
      input :intro
      input :outro
      input :video_editor_instructions
      input :intro_outro_design_ideas
      input :design_style
      input :design_ideas
      input :editor_brief
      input :srt
      input :summary
      input :abridgement
      input :abridgement_descrepencies
      input :analyze_content_essence
      input :analyze_audience_engagement
      input :analyze_cta_competitors
      input :video_title
      input :video_url
      input :video_topic_theme
      input :video_related_links
      input :video_keywords
      input :video_description
      input :video_description_custom_gpt
      input :video_pinned_comment
      input :video_metadata
      input :content_highlights
      input :identify_chapters
      input :refine_chapters
      input :chapters
      input :fold_cta
      input :primary_cta
      input :affiliate_cta
      input :brand_info
      input :title_ideas
      input :thumbnail_text
      input :thumbnail_text_csv
      input :thumbnail_visual_elements
      input :tweet_content
      input :facebook_post
      input :linkedin_post
      input :shorts_title
      input :shorts_description
      input :outcome_notes
      prompt :outcome_notes_prompt
      output :outcome_notes
    end
  end

  section 'Content Analysis' do
    step 'Content Essence' do
      input :abridgement
      input :analyze_content_essence
      input :video_topic_theme        # (Main Topic or Theme)
      input :video_keywords
      input :content_highlights       # (Keywords/Insites/Takeaways/Audience-Related Insights)
      prompt :analyze_content_essence_prompt
      output :analyze_content_essence
    end

    step 'Audience Engagement' do
      input :abridgement
      input :analyze_content_essence
      input :analyze_audience_engagement
      prompt :analyze_audience_engagement_prompt
      output :analyze_audience_engagement
    end

    step 'CTA/Competitors' do
      input :abridgement
      input :analyze_content_essence
      input :analyze_audience_engagement
      input :analyze_cta_competitors
      prompt :analyze_cta_competitors_prompt
      output :analyze_cta_competitors
    end

    step 'Outcome Notes' do
      input :gpt_links
      input :short_title
      input :transcript
      input :intro
      input :outro
      input :video_editor_instructions
      input :intro_outro_design_ideas
      input :design_style
      input :design_ideas
      input :editor_brief
      input :srt
      input :summary
      input :abridgement
      input :abridgement_descrepencies
      input :analyze_content_essence
      input :analyze_audience_engagement
      input :analyze_cta_competitors
      input :video_title
      input :video_url
      input :video_topic_theme
      input :video_related_links
      input :video_keywords
      input :video_description
      input :video_description_custom_gpt
      input :video_pinned_comment
      input :video_metadata
      input :content_highlights
      input :identify_chapters
      input :refine_chapters
      input :chapters
      input :fold_cta
      input :primary_cta
      input :affiliate_cta
      input :brand_info
      input :title_ideas
      input :thumbnail_text
      input :thumbnail_text_csv
      input :thumbnail_visual_elements
      input :tweet_content
      input :facebook_post
      input :linkedin_post
      input :shorts_title
      input :shorts_description
      input :outcome_notes
      prompt :outcome_notes_prompt
      output :outcome_notes
    end
  end

  section 'Title & Thumbnail' do
    step 'Title Ideas' do
      input :short_title              #
      input :video_topic_theme        # (Main Topic or Theme)
      input :content_highlights       # (Keywords/Insites/Takeaways/Audience-Related Insights)
      prompt :title_generation_prompt
      output :title_ideas
    end

    # Analyze Title Short List
    # Here are the types of prompts or questions you've been writing:

    # Title Analysis: Requesting evaluations of YouTube titles.
    # Title Suggestions: Asking for new or varied title options.
    # Title Optimization: Seeking ways to improve existing titles.
    # Comparative Analysis: Comparing and analyzing different title versions.
    # Content Strategy: Discussing factors influencing YouTube CTR.
    # Instructional Requests: Asking for concise, actionable recommendations.
    # These types cover the main focus areas of your queries related to optimizing and refining YouTube content titles.

    step 'Thumb Text Ideas' do
      input :video_title
      input :video_topic_theme
      input :content_highlights
      input :title_ideas
      prompt :thumbnail_text_prompt
      output :thumbnail_text
    end

    step 'Thumb Text CSV' do
      input :thumbnail_text
      prompt :thumbnail_text_csv_prompt
      output :thumbnail_text_csv
    end

    step 'THUMB THUMB THUMB' do
      # https://websim.ai/@wonderwhy_er/youtube-thumbnail-brainstormer
    end

    step 'Visual Element Ideas' do
      input :video_title
      input :content_highlights
      input :title_ideas
      prompt :thumbnail_visual_elements_prompt
      output :thumbnail_visual_elements
    end

    # Does the Title, Thumbnail Text and Visual Elements align with the content or is it misleading?
    step 'Outcome Notes' do
      input :gpt_links
      input :short_title
      input :transcript
      input :intro
      input :outro
      input :video_editor_instructions
      input :intro_outro_design_ideas
      input :design_style
      input :design_ideas
      input :editor_brief
      input :srt
      input :summary
      input :abridgement
      input :abridgement_descrepencies
      input :analyze_content_essence
      input :analyze_audience_engagement
      input :analyze_cta_competitors
      input :video_title
      input :video_url
      input :video_topic_theme
      input :video_related_links
      input :video_keywords
      input :video_description
      input :video_description_custom_gpt
      input :video_pinned_comment
      input :video_metadata
      input :content_highlights
      input :identify_chapters
      input :refine_chapters
      input :chapters
      input :fold_cta
      input :primary_cta
      input :affiliate_cta
      input :brand_info
      input :title_ideas
      input :thumbnail_text
      input :thumbnail_text_csv
      input :thumbnail_visual_elements
      input :tweet_content
      input :facebook_post
      input :linkedin_post
      input :shorts_title
      input :shorts_description
      input :outcome_notes
      prompt :outcome_notes_prompt
      output :outcome_notes
    end

  end

  section 'YouTube Meta Data' do
    step 'Simple Description' do
      input :video_title
      input :video_keywords
      input :abridgement
      prompt :yt_simple_description_prompt
      output :video_simple_description
    end

    step 'Write Description' do
      input :video_title
      input :chapters
      input :video_simple_description
      input :brand_info
      input :fold_cta
      input :primary_cta
      input :affiliate_cta
      input :video_related_links
      input :video_keywords
      prompt :yt_description_prompt
      output :video_description
    end

    step 'Format Description' do
      input :video_description
      prompt :yt_format_description_prompt
      output :video_description
    end

    step 'Custom GPT Description' do
      input :video_title
      input :chapters
      input :abridgement
      input :brand_info
      input :fold_cta
      input :primary_cta
      input :affiliate_cta
      input :video_related_links
      input :video_keywords
      prompt :yt_description_custom_gpt_prompt
      output :video_description_custom_gpt
    end

    step 'Pinned Comment' do
      # I don't need all these, but not sure which ones I do need yet
      input :video_title
      input :abridgement
      input :chapters
      input :brand_info
      input :fold_cta
      input :primary_cta
      input :affiliate_cta
      input :video_related_links
      input :video_keywords
      input :video_description
      prompt :yt_pinned_comment_prompt
      output :video_pinned_comment
    end

    step 'Extra Metadata' do
      input :video_title
      input :abridgement
      prompt :yt_metadata_prompt
      output :video_metadata
    end

    step 'Outcome Notes' do
      input :gpt_links
      input :short_title
      input :transcript
      input :intro
      input :outro
      input :video_editor_instructions
      input :intro_outro_design_ideas
      input :design_style
      input :design_ideas
      input :editor_brief
      input :srt
      input :summary
      input :abridgement
      input :abridgement_descrepencies
      input :analyze_content_essence
      input :analyze_audience_engagement
      input :analyze_cta_competitors
      input :video_title
      input :video_url
      input :video_topic_theme
      input :video_related_links
      input :video_keywords
      input :video_description
      input :video_description_custom_gpt
      input :video_pinned_comment
      input :video_metadata
      input :content_highlights
      input :identify_chapters
      input :refine_chapters
      input :chapters
      input :fold_cta
      input :primary_cta
      input :affiliate_cta
      input :brand_info
      input :title_ideas
      input :thumbnail_text
      input :thumbnail_text_csv
      input :thumbnail_visual_elements
      input :tweet_content
      input :facebook_post
      input :linkedin_post
      input :shorts_title
      input :shorts_description
      input :outcome_notes
      prompt :outcome_notes_prompt
      output :outcome_notes
    end
  end

  section 'Social Media Posts' do
    step 'Create Tweet' do
      input :video_title
      input :video_link
      input :video_keywords
      input :summary
      prompt :tweet_prompt
      output :tweet_content
    end

    step 'Create FB Post' do
      input :summary
      input :video_keywords
      prompt :facebook_post_prompt
      output :facebook_post
    end

    step 'Create LinkedIn Post' do
      input :video_title
      input :video_link
      input :video_keywords
      input :abridgement
      prompt :linkedin_post_prompt
      output :linkedin_post
    end

    step 'Outcome Notes' do
      input :short_title
      input :transcript
      input :intro
      input :outro
      input :video_editor_instructions
      input :intro_outro_design_ideas
      input :design_style
      input :design_ideas
      input :editor_brief
      input :srt
      input :summary
      input :abridgement
      input :abridgement_descrepencies
      input :analyze_content_essence
      input :analyze_audience_engagement
      input :analyze_cta_competitors
      input :video_title
      input :video_url
      input :video_topic_theme
      input :video_related_links
      input :video_keywords
      input :video_description
      input :video_description_custom_gpt
      input :video_pinned_comment
      input :video_metadata
      input :content_highlights
      input :identify_chapters
      input :refine_chapters
      input :chapters
      input :fold_cta
      input :primary_cta
      input :affiliate_cta
      input :brand_info
      input :title_ideas
      input :thumbnail_text
      input :thumbnail_text_csv
      input :thumbnail_visual_elements
      input :tweet_content
      input :facebook_post
      input :linkedin_post
      input :shorts_title
      input :shorts_description
      input :outcome_notes
      prompt :outcome_notes_prompt
      output :outcome_notes
    end
  end

  section 'YouTube Shorts' do
    step 'Shorts Context' do
      input :abridgement
      prompt :shorts_context_prompt
      output :shorts_context      
    end

    step 'Create Shorts Title' do
      input :short_transcription
      input :abridgement
      prompt :shorts_title_prompt
      output :shorts_title      
    end

    step 'Create Shorts Description' do
      input :short_transcription
      input :abridgement
      prompt :shorts_description_prompt
      output :shorts_description
    end

  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/youtube-launch-optimizer.json'
dsl
  .save
  .save_json(file)
