# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::AttributeDsl do
  let(:instance) { described_class.new(workflow) }
  let(:dsl) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:workflow) { dsl.workflow }

  context 'when attributes are added to workflow' do
    subject { workflow[:attributes] }

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
