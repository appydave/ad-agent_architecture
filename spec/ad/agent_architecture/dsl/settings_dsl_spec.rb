# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::SettingsDsl do
  let(:instance) { described_class.new(workflow) }
  let(:dsl) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:workflow) { dsl.workflow }

  context 'when settings are added to workflow' do
    subject { instance }

    before do
      instance.some_path('/path/to/prompts')
      instance.name('AppyDave')
    end

    it { is_expected.to include(some_path: '/path/to/prompts', name: 'AppyDave') }
  end
end
