# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::PromptDsl do
  subject { described_class.new(prompts) }

  let(:workflow) { { prompts: {} } }
  let(:prompts) { workflow[:prompts] }

  describe '#prompt' do
    it 'adds a prompt to the workflow using path' do
      subject.prompt :best_practice, path: 'youtube/title_creator/best_practice.md'
      expect(workflow[:prompts]).to include(:best_practice)
      expect(workflow[:prompts][:best_practice]).to include(name: :best_practice, path: 'youtube/title_creator/best_practice.md')
    end

    # spec/ad/agent_architecture/dsl/prompt_dsl_spec.rb:16:5: C: RSpec/MultipleExpectations: Example has too many expectations [2/1].
    it 'adds a prompt to the workflow using content' do
      subject.prompt :best_practice, content: 'Use the following best practices to create a title for your YouTube video.'
      expect(workflow[:prompts]).to include(:best_practice)
      expect(workflow[:prompts][:best_practice]).to include(name: :best_practice, content: 'Use the following best practices to create a title for your YouTube video.')
    end
  end
end
