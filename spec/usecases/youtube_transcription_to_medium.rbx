# frozen_string_literal: true

dsl = Agent.create(name: 'YouTube Transcript to Medium Article') do
  attributes do
    attribute :transcript, type: :string
    attribute :outline, type: :string
    attribute :first_draft, type: :string
    attribute :intro_variations, type: :array
    attribute :intro_variation, type: :string
    attribute :second_draft, type: :string
    attribute :intro_analysis, type: :string
    attribute :intro_analysis_combined, type: :string
  end

  section(name: 'Analysis') do
    step(name: 'Generate Outline') do
      input :transcript                                                                         , file: '00-trascript.txt'
      prompt 'Analyze [transcript] and generate a preliminary outline for a blog post.'         , file: '01-1-transcript-outline.md'
      output :outline                                                                           , file: '01-2-transcript-outline-OUTPUT.md'
    end

    step(name: 'Write First Draft') do
      input :outline                                                                            , file: '01-2-transcript-outline-OUTPUT.md'
      prompt 'Write a blog post based on [outline].'                                            , file: '02-1-first-draft.md'
      output :first_draft                                                                       , file: '02-2-first-draft-OUTPUT.md'
    end

    step(name: 'Generate Intros') do
      input :first_draft                                                                        , file: '02-2-first-draft-OUTPUT.md'
      prompt 'Create 5 introduction variations for [first_draft].'                              , file: '03-1-intro-variations.md'
      output :intro_variations                                                                  , file: '03-2-intro-variations-OUTPUT.md'
    end

    step(name: 'Update Draft with Intro') do
      # note 'This step is a loop based on the intro_variations attribute, a new branch is created for each variation'
      input :first_draft                                                                        , file: '02-2-first-draft-OUTPUT.md'
      input :intro_variation                                                                    , value: 'Here is a cool introduction'
      prompt 'Update [first_draft] with a better intro [intro_variation].'                      , file: '04-1-intro-update.md'
      output :second_draft                                                                      , file: '04-2-intro-update-OUTPUT.md'
    end

    step(name: 'Analyse Intro') do
      input :second_draft                                                                       , file: '04-2-intro-update-OUTPUT.md'
      prompt 'Analyze the article [second_draft] introduction'                                  , file: '05-1-intro-critique.md'
      output :intro_analysis                                                                    , file: '05-2-intro-critique-OUTPUT.md'
    end

    step(name: 'Combine Intro Analysis') do
      # note 'This is a custom place holder for intro analisis for each intro variation'
      output :intro_analysis_combined , file: '06-2-intro-analysis-combined.md'
    end
  end
end

dsl
  .save
  .save_json('workflow.json')
  .save_yaml('workflow.yaml')

workflow = Ad::AgentArchitecture::Database::Workflow.first(name: 'YouTube Transcript to Medium Article')

Ad::AgentArchitecture::Report::WorkflowDetailReport.new.print(workflow)
Ad::AgentArchitecture::Report::WorkflowListReport.new.print
