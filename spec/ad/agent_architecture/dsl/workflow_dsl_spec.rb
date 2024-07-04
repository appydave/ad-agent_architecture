# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::WorkflowDsl do
  let(:instance) { described_class.new(name) }

  let(:name) { 'Blog Post Workflow' }

  context 'when workflow is instantiated' do
    subject { instance.data }

    it { is_expected.to include(name: 'Blog Post Workflow', sections: [], attributes: {}, prompts: {}, settings: {}) }
  end

  context 'when attributes are added to workflow' do
    subject { instance.data[:attributes] }

    before do
      instance.attributes do
        attribute :transcript, type: :string
        attribute :outline, type: :string
        attribute :keywords, type: :string, is_array: true
      end
    end

    it {
      expect(subject).to include(
        transcript: { name: :transcript, type: :string, is_array: false },
        outline: { name: :outline, type: :string, is_array: false },
        keywords: { name: :keywords, type: :string, is_array: true }
      )
    }
  end

  context 'when prompts are added to workflow' do
    subject { instance.data[:prompts] }

    before do
      instance.prompts do
        prompt :transcript, content: 'Enter the transcript of the blog post.'
      end
    end

    it { is_expected.to include(transcript: { content: 'Enter the transcript of the blog post.', name: :transcript }) }
  end

  context 'when settings are added to workflow' do
    subject { instance.data[:settings] }

    before do
      instance.settings do
        path_to_prompts '/path/to/prompts'
      end
    end

    it { is_expected.to include(path_to_prompts: '/path/to/prompts') }
  end
end
