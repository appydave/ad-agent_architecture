# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::ChildDsl do
  let(:workflow) { { name: 'Test Workflow', settings: {}, attributes: {}, prompts: {}, sections: [] } }
  let(:instance) { described_class.new(workflow) }

  describe '#initialize' do
    it 'initializes with the given workflow' do
      expect(instance.workflow).to eq(workflow)
    end
  end

  context 'when interacting with the workflow hash' do
    it 'allows reading the workflow hash' do
      expect(instance.workflow[:name]).to eq('Test Workflow')
    end

    it 'allows modifying the workflow hash' do
      instance.workflow[:settings][:new_setting] = 'value'
      expect(instance.workflow[:settings][:new_setting]).to eq('value')
    end
  end
end
