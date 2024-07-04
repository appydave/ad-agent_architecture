# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::ChildDsl do
  let(:workflow) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Test Workflow') }
  let(:instance) { described_class.new(workflow) }

  describe '#initialize' do
    it 'initializes with the given workflow' do
      expect(instance.workflow).to eq(workflow)
    end
  end

  describe '#data' do
    it 'returns the workflow data' do
      expect(instance.data).to eq(workflow.data)
    end
  end

  describe '#settings' do
    it 'returns the settings hash from the workflow data' do
      expect(instance.settings).to eq(workflow.data[:settings])
    end
  end

  describe '#get_setting' do
    before do
      workflow.data[:settings][:test_setting] = 'value'
    end

    it 'retrieves a setting by name' do
      expect(instance.get_setting(:test_setting)).to eq('value')
    end
  end

  describe '#attributes' do
    it 'returns the attributes hash from the workflow data' do
      expect(instance.attributes).to eq(workflow.data[:attributes])
    end
  end

  describe '#get_attribute' do
    before do
      workflow.data[:attributes][:test_attribute] = { name: :test_attribute, type: :string }
    end

    it 'retrieves an attribute by name' do
      expect(instance.get_attribute(:test_attribute)).to eq({ name: :test_attribute, type: :string })
    end
  end

  describe '#prompts' do
    it 'returns the prompts hash from the workflow data' do
      expect(instance.prompts).to eq(workflow.data[:prompts])
    end
  end

  describe '#get_prompt' do
    before do
      workflow.data[:prompts][:test_prompt] = { name: :test_prompt, content: 'content' }
    end

    it 'retrieves a prompt by name' do
      expect(instance.get_prompt(:test_prompt)).to eq({ name: :test_prompt, content: 'content' })
    end
  end
end
