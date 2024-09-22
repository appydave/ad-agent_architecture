dsl = Agent.create(:youtube_launch_optimizer) do
  description 'This workflow optimizes video launch by analyzing, preparing, and generating content for various platforms.'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/youtube/launch_optimizer')
    default_llm :gpt4o
  end

  prompts do
    prompt :video_summary_prompt              , content: load_file("1-1-summarize-video.txt")
    prompt :video_abridgement_prompt          , content: load_file("1-2-1-abridge-video.txt")
    prompt :abridgement_descrepencies_prompt  , content: load_file("1-3-abridge-video-descrepencies.txt")
    prompt :intro_outro_seperation_prompt     , content: load_file("1-4-seperate-intro-outro.txt")
    prompt :transcript_broll_prompt           , content: load_file("1-5-transcript-broll.txt")
    prompt :identify_chapters_prompt          , content: load_file("2-1-identify-chapters.txt")
    prompt :refine_chapters_prompt            , content: load_file("2-2-refine-chapters.txt")
    prompt :create_chapters_prompt            , content: load_file("2-3-create-chapters.txt")
    prompt :analyze_content_essence_prompt    , content: load_file("3-1-analyze-content-essence.txt")
    prompt :analyze_audience_engagement_prompt, content: load_file("3-2-analyze-audience-engagement.txt")
    prompt :analyze_cta_competitors_prompt    , content: load_file("3-3-analyze-cta-competitors.txt")
    prompt :title_generation_prompt           , content: load_file("4-1-generate-title.txt")
    prompt :thumbnail_text_prompt             , content: load_file("4-2-generate-thumbnail-text.txt")
    prompt :thumbnail_visual_elements_prompt  , content: load_file("4-3-thumbnail-visual-elements.txt")
    prompt :yt_simple_description_prompt      , content: load_file("5-1-yt-simple-description.txt")
    prompt :yt_description_prompt             , content: load_file("5-2-yt-write-description.txt")
    prompt :yt_format_description_prompt      , content: load_file("5-3-yt-format-description.txt")
    prompt :yt_description_custom_gpt_prompt  , content: load_file("5-4-yt-description-custom-gpt.txt")
    prompt :yt_pinned_comment_prompt          , content: load_file("5-5-yt-pinned-comment.txt") 
    prompt :yt_metadata_prompt                , content: load_file("5-6-yt-meta-data.txt")
    prompt :tweet_prompt                      , content: load_file("6-1-create-tweet.txt")
    prompt :facebook_post_prompt              , content: load_file("6-2-create-fb-post.txt")
    prompt :linkedin_post_prompt              , content: load_file("6-3-create-linkedin-post.txt")
  end

  attributes do
    attribute :short_title, type: :string
    attribute :transcript, type: :string
    attribute :intro, type: :string
    attribute :outro, type: :string
    attribute :transcript_broll, type: :string
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
    attribute :video_description_custom_gpt, type: :string
    attribute :video_pinned_comment, type: :string
    attribute :video_metadata, type: :string
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
    attribute :thumbnail_visual_elements, type: :string
    attribute :tweet_content, type: :string
    attribute :facebook_post, type: :string
    attribute :linkedin_post, type: :string
  end

  # Clean SRT
  # Intro/Outro/Content Seperation
  # Chapter Name Suggeestions
  # B-Roll Suggestions
  # section('Transcript Analysis') do
  #   step('')
  # end

  section('Video Preparation') do
    step('Configure') do
      input :brand_info
      input :short_title
      input :video_title
      input :video_url
      input :video_related_links
      input :video_keywords
      input :fold_cta
      input :primary_cta
      input :affiliate_cta
      input :chapters
      input :transcript
      input :abridgement
      input :summary
    end

    step('Script Summary') do
      input :transcript
      prompt :video_summary_prompt
      output :summary
    end

    step('Script Abridgement') do
      input :transcript
      prompt :video_abridgement_prompt
      output :abridgement
    end

    step('Abridge QA') do
      input :transcript
      input :abridgement
      prompt :abridgement_descrepencies_prompt
      output :abridgement_descrepencies
    end

    step('Intro/Outro Seperation') do
      input :transcript
      prompt :intro_outro_seperation_prompt
      output :intro
      output :outro
    end

    step('Transcript B-Roll') do
      input :transcript
      prompt :transcript_broll_prompt
      output :transcript_broll
    end
  end

  section('Build Chapters') do
    step('Find Chapters') do
      input :transcript
      input :abridgement
      prompt :identify_chapters_prompt
      output :identify_chapters
    end

    step('Refine Chapters') do
      input :identify_chapters
      input :refine_chapters
      prompt :refine_chapters_prompt
      output :chapters
    end

    step('Create Chapters') do
      input :chapters
      input :srt
      prompt :create_chapters_prompt
      output :chapters
    end
  end

  section('Content Analysis') do
    step('Content Essence') do
      input :abridgement
      prompt :analyze_content_essence_prompt
      output :analyze_content_essence
    end

    step('Audience Engagement') do
      input :abridgement
      prompt :analyze_audience_engagement_prompt
      output :analyze_audience_engagement
    end

    step('CTA/Competitors') do
      input :abridgement
      prompt :analyze_cta_competitors_prompt
      output :analyze_cta_competitors
    end

    # step('Analyze Video') do
    #   input :transcript
    #   prompt :analyze_content_essence_prompt
    #   output :video_topic
    #   output :video_keywords
    # end
  end

  section('Title & Thumbnail') do
    step('Title Ideas') do
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

    step('Thumb Text Ideas') do
      input :video_title
      input :video_topic_theme
      input :content_highlights
      input :title_ideas
      prompt :thumbnail_text_prompt
      output :thumbnail_text
    end

    step('Visual Element Ideas') do
      input :video_title
      input :content_highlights
      input :title_ideas
      prompt :thumbnail_visual_elements_prompt
      output :thumbnail_visual_elements
    end

    # Does the Title, Thumbnail Text and Visual Elements align with the content or is it misleading?
  end

  section('YouTube Meta Data') do
    step('Simple Description') do
      input :video_title
      input :video_keywords
      input :abridgement
      prompt :yt_simple_description_prompt
      output :video_simple_description
    end

    step('Write Description') do
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

    step('Format Description') do
      input :video_description
      prompt :yt_format_description_prompt
      output :video_description
    end

    step('Custom GPT Description') do
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

    step('Pinned Comment') do
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

    step('Extra Metadata') do
      input :video_title
      input :abridgement
      prompt :yt_metadata_prompt
      output :video_metadata
    end

  end

  section('Social Media Posts') do
    step('Create Tweet') do
      input :video_title
      input :video_link
      input :video_keywords
      input :summary
      prompt :tweet_prompt
      output :tweet_content
    end

    step('Create FB Post') do
      input :summary
      input :video_keywords
      prompt :facebook_post_prompt
      output :facebook_post
    end

    step('Create LinkedIn Post') do
      input :video_title
      input :video_link
      input :video_keywords
      input :abridgement
      prompt :linkedin_post_prompt
      output :linkedin_post
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/youtube-launch-optimizer.json'
dsl
  .save
  .save_json(file)
