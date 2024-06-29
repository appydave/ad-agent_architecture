# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::AgentWorkflowDsl do
  it 'test usage' do
    puts 'xxxx'

    described_class.create(name: 'YouTube Transcript to Medium Article') do
      attributes do
        attribute :transcript, type: :string
        attribute :outline, type: :string
        attribute :first_draft, type: :string
        attribute :intro_variations, type: :array
        attribute :seo_analysis, type: :string
      end

      section(name: 'Analysis') do
        step(name: 'Generate Outline') do
          input :transcript, file: '00-trascript.txt'
          prompt 'Analyze [transcript] and generate a preliminary outline for a blog post.', file: '01-1-transcript-outline.md'
          output :outline, file: '01-2-transcript-outline-OUTPUT.md'
        end

        step(name: 'Write First Draft') do
          input :outline, file: '01-2-transcript-outline-OUTPUT.md'
          prompt 'Write a blog post based on [outline].', file: '02-1-first-draft.md'
          output :first_draft, file: '02-2-first-draft-OUTPUT.md'
        end

        step(name: 'Generate Intros') do
          input :first_draft, file: '02-2-first-draft-OUTPUT.md'
          prompt 'Create 5 introduction variations for [first_draft].', file: '03-1-intro-variations.md'
          output :intro_variations, file: '03-2-intro-variations-OUTPUT.md'
        end

        step(name: 'SEO Analysis') do
          input :first_draft, file: '02-2-first-draft-OUTPUT.md'
          prompt 'Analyze the blog post for SEO.', file: '04-1-seo-analysis-prompt.md'
          output :seo_analysis, file: '04-2-seo-analysis-OUTPUT.md'
        end
      end
    end

    # Assuming you have a workflow object available
    workflow = Ad::AgentArchitecture::Database::Workflow.first(name: 'YouTube Transcript to Medium Article')

    # Print the workflow details using k_log
    report = Ad::AgentArchitecture::Report::WorkflowDetailReport.new
    report.print(workflow)

    Ad::AgentArchitecture::Report::WorkflowListReport.new.print
  end
end
