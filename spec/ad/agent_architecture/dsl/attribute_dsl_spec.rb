# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::AttributeDsl do
  let(:instance) { described_class.new(workflow) }
  let(:workflow) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:data) { workflow.data }

  context 'when adding attribute to workflow' do
    subject { data[:attributes] }

    context 'when standard format' do
      before do
        instance.attribute(:title)
        instance.attribute(:items, type: :something, is_array: true)
      end

      it 'includes the added attributes' do
        expect(subject).to include(
          title: { name: :title, type: :string, is_array: false, description: nil },
          items: { name: :items, type: :something, is_array: true, description: nil }
        )
      end
    end

    context 'when attribute using block' do
      before do
        instance.attribute(:title) do
          description 'This is a title'
          type :something_else
          is_array true
        end
      end

      it 'includes the added attributes' do
        expect(subject).to include(
          title: { name: :title, type: :something_else, is_array: true, description: 'This is a title' }
        )
      end
    end

    context 'when using fluent interface' do
      before do
        instance.attribute(:title).description('This is a title').type(:something_else).is_array(true)
      end

      it 'includes the added attributes' do
        expect(subject).to include(
          title: { name: :title, type: :something_else, is_array: true, description: 'This is a title' }
        )
      end
    end
  end
end
