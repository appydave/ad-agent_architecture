AgentWorkflow 'YouTube Transcript to Medium Article' do
  description 'Converts YouTube transcripts into Medium articles.'

  attributes do
    attribute :transcript, required: true
    attribute :outline, required: true
    attribute :first_draft, required: true
    attribute :intro_variations, rray: true
    attribute :intro_variation
    attribute :second_draft, required: true
    attribute :intro_analysis
    attribute :intro_analysis_combined
  end

  prompts do
    prompt :best_practice, path: 'youtube/transcript_to_medium/best_practice.md'
  end

  section 'Analysis' do
    step 'Generate Outline' do
      input :transcript
      output :outline
      prompt 'Analyze [transcript] and generate a preliminary outline for a blog post.'
    end

    step 'Write First Draft' do
      input :outline
      output :first_draft
      prompt 'Write a blog post based on [outline].'
    end
  end

  section 'Drafting' do
    step 'Write Second Draft' do
      input :second_draft
      output :second_draft
      prompt 'Write a second draft of the article based on [second_draft].'
    end

    step 'Update Draft with Intro Analysis' do
      input :intro_analysis_combined
      output :second_draft
      prompt 'Update [second_draft] with the intro analysis [intro_analysis_combined].'
    end
  end
end
