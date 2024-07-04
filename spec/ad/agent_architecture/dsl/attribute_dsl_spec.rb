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

  context 'when infer_attribute is called' do
    subject { data[:attributes] }

    before do
      instance.infer_attribute(:description)
      instance.infer_attribute(:tags)
    end

    it 'infers the type for new attributes' do
      expect(subject).to include(
        description: { name: :description, type: 'string', is_array: false },
        tags: { name: :tags, type: 'array', is_array: true }
      )
    end

    it 'does not override existing attributes' do
      instance.attribute(:description, type: :text)
      instance.infer_attribute(:description)
      expect(subject[:description]).to eq({ name: :description, type: :text, is_array: false })
    end
  end
end
