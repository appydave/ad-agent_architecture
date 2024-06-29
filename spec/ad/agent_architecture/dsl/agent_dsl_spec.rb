# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::AgentDsl do
  let(:instance) { described_class.new(name) }

  let(:name) { 'Blog Post Workflow' }

  context 'when agent is instantiated' do
    subject { instance.workflow.workflow }

    it { is_expected.to include(name: 'Blog Post Workflow', sections: [], attributes: {}, prompts: {}) }
  end

  context 'when attributes are added to agent' do
    subject { instance.workflow.workflow[:attributes] }

    before do
      instance.attributes do
        attribute :transcript, type: :string
      end
    end

    it { is_expected.to include(transcript: { name: :transcript, type: :string, is_array: false }) }
  end

  context 'when prompts are added to agent' do
    subject { instance.workflow.workflow[:prompts] }

    before do
      instance.prompts do
        prompt :transcript, content: 'Enter the transcript of the blog post.'
      end
    end

    it { is_expected.to include(transcript: { content: 'Enter the transcript of the blog post.', name: :transcript, path: nil }) }
  end

  context 'when section is added to agent' do
    subject { instance.workflow.workflow[:sections] }

    before do
      instance.section(name: 'Section 1')
    end

    it { is_expected.to include(name: 'Section 1', order: 1, steps: []) }
  end

  context 'when agent is saved' do
    let(:save_database_instance) { instance_double(Ad::AgentArchitecture::Dsl::Actions::SaveDatabase) }

    before do
      allow(Ad::AgentArchitecture::Dsl::Actions::SaveDatabase).to receive(:new).and_return(save_database_instance)
      allow(save_database_instance).to receive(:save)
    end

    it 'calls the save method of the SaveDatabase class' do
      instance.save
      expect(save_database_instance).to have_received(:save)
    end
  end

  context 'when agent is saved as JSON' do
    let(:save_json_instance) { instance_double(Ad::AgentArchitecture::Dsl::Actions::SaveJson) }

    before do
      allow(Ad::AgentArchitecture::Dsl::Actions::SaveJson).to receive(:new).and_return(save_json_instance)
      allow(save_json_instance).to receive(:save)
    end

    it 'calls the save method of the SaveJson class' do
      instance.save_json
      expect(save_json_instance).to have_received(:save)
    end
  end
end
