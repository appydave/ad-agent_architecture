start_time = Time.now

dsl = Agent.create(:youtube_publish_video) do
  description 'This workflow assists in publishing a YouTube video, covering thumbnail design, factsheet creation, and social content generation.'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/youtube_publish_video')
    default_llm :gpt4o
  end

  prompts do
    prompt :create_title               , content: load_file("sample-prompt.txt") #("1-1-create_title.txt")
    prompt :create_thumbnail_text      , content: load_file("sample-prompt.txt") #("1-2-create_thumbnail_text.txt")
    prompt :thumbnail_design_guide     , content: load_file("sample-prompt.txt") #("1-3-thumbnail_design_guide.txt")
    prompt :transcript_summary         , content: load_file("sample-prompt.txt") #("2-1-transcript_summary.txt")
    prompt :transcript_abridgment      , content: load_file("sample-prompt.txt") #("2-2-transcript_abridgment.txt")
    prompt :chapters                   , content: load_file("sample-prompt.txt") #("2-3-chapters.txt")
    prompt :brand_information          , content: load_file("sample-prompt.txt") #("2-4-brand_information.txt")
    prompt :youtube_description        , content: load_file("sample-prompt.txt") #("3-1-youtube_description.txt")
    prompt :linkedin_post              , content: load_file("sample-prompt.txt") #("3-2-linkedin_post.txt")
    prompt :tweet                      , content: load_file("sample-prompt.txt") #("3-3-tweet.txt")
    prompt :medium_article             , content: load_file("sample-prompt.txt") #("3-4-medium_article.txt")
  end

  attributes do
    attribute :video_title, type: :string
    attribute :thumbnail_text, type: :string
    attribute :thumbnail_design, type: :string
    attribute :transcript, type: :string
    attribute :summary, type: :string
    attribute :abridgment, type: :string
    attribute :chapters, type: :array
    attribute :brand_info, type: :string
    attribute :youtube_desc, type: :string
    attribute :linkedin_post, type: :string
    attribute :tweet, type: :string
    attribute :medium_article, type: :string
  end

  section('Thumbnail Design') do
    step('Create Title') do
      input :video_title
      prompt :create_title
      output :video_title
    end

    step('Create Thumbnail Text') do
      input :video_title
      prompt :create_thumbnail_text
      output :thumbnail_text
    end

    step('Thumbnail Design Guide Line') do
      input :thumbnail_text
      prompt :thumbnail_design_guide
      output :thumbnail_design
    end
  end

  section('Factsheet') do
    step('Transcript Summary') do
      input :transcript
      prompt :transcript_summary
      output :summary
    end

    step('Transcript Abridgment') do
      input :transcript
      prompt :transcript_abridgment
      output :abridgment
    end

    step('Chapters') do
      input :transcript
      prompt :chapters
      output :chapters
    end

    step('Brand Information') do
      prompt :brand_information
      output :brand_info
    end
  end

  section('Social Content') do
    step('YouTube Description') do
      input :abridgment
      prompt :youtube_description
      output :youtube_desc
    end

    step('Linked In Post') do
      input :abridgment
      input :brand_info
      prompt :linkedin_post
      output :linkedin_post
    end

    step('Tweet') do
      input :summary
      prompt :tweet
      output :tweet
    end

    step('Medium Article') do
      input :summary
      input :abridgment
      input :brand_info
      prompt :medium_article
      output :medium_article
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/youtube-publish-video.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
