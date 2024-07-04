# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::SettingsDsl do
  let(:instance) { described_class.new(workflow) }
  let(:workflow) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:data) { workflow.data }

  context 'when settings are added to workflow' do
    subject { instance }

    before do
      instance.some_path('/path/to/prompts')
      instance.name('AppyDave')
    end

    it { is_expected.to include(some_path: '/path/to/prompts', name: 'AppyDave') }
  end
end
