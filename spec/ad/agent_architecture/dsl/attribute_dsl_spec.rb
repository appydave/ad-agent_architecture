# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::AttributeDsl do
  let(:instance) { described_class.new(workflow) }
  let(:workflow) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:data) { workflow.data }

  context 'when attributes are added to workflow' do
    subject { data[:attributes] }

    before do
      instance.attribute(:title, type: :string)
      instance.attribute(:items, type: :string, is_array: true)
    end

    it 'includes the added attributes' do
      expect(subject).to include(
        title: { name: :title, type: :string, is_array: false },
        items: { name: :items, type: :string, is_array: true }
      )
    end
  end
end
