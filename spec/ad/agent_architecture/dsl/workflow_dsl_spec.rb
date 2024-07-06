# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::WorkflowDsl do
  let(:instance) { described_class.new(name, description: description) }

  let(:name) { 'Blog Post Workflow' }
  let(:description) { nil }

  context 'when workflow is instantiated' do
    subject { instance.data }

    it { is_expected.to include(name: 'Blog Post Workflow', description: nil, sections: [], attributes: {}, prompts: {}, settings: {}) }

    context 'when description is set via constructor' do
      let(:description) { 'This is a workflow for creating a blog post' }

      it { is_expected.to include(name: 'Blog Post Workflow', description: 'This is a workflow for creating a blog post', sections: [], attributes: {}, prompts: {}, settings: {}) }
    end

    context 'when description is set via method' do
      before { instance.description('New description') }

      it { is_expected.to include(name: 'Blog Post Workflow', description: 'New description', sections: [], attributes: {}, prompts: {}, settings: {}) }
    end
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
        transcript: { name: :transcript, type: :string, is_array: false, description: nil },
        outline: { name: :outline, type: :string, is_array: false, description: nil },
        keywords: { name: :keywords, type: :string, is_array: true, description: nil }
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

    it { is_expected.to include(transcript: { content: 'Enter the transcript of the blog post.', name: :transcript, description: nil, path: nil }) }
  end

  context 'when settings are added to workflow' do
    subject { instance.data[:settings] }

    before do
      instance.settings do
        path_to_prompts '/path/to/prompts'
      end
    end

    it { is_expected.to include(path_to_prompts: { value: '/path/to/prompts', description: nil }) }
  end
end
