# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::AttributeDsl do
  subject { described_class.new(attributes) }

  let(:workflow) { { attributes: {} } }
  let(:attributes) { workflow[:attributes] }

  describe '#attribute' do
    it 'adds an attribute to the workflow' do
      subject.attribute :title, type: :string
      expect(workflow[:attributes]).to include(:title)
      expect(workflow[:attributes][:title]).to include(name: :title, type: :string)
    end
  end
end
