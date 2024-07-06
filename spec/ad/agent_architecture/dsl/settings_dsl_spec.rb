# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::SettingsDsl do
  let(:instance) { described_class.new(workflow) }
  let(:workflow) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:data) { workflow.data }

  context 'when settings are added to workflow' do
    subject { instance }

    before do
      instance.some_path('/path/to/prompts')
      instance.name('AppyDave', description: 'AppyDave description')
    end

    it 'includes the settings with values and descriptions' do
      expect(data[:settings][:some_path]).to include(value: '/path/to/prompts', description: nil)
      expect(data[:settings][:name]).to include(value: 'AppyDave', description: 'AppyDave description')
    end
  end
end
