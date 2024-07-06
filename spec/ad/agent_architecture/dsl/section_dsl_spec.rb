# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::SectionDsl do
  let(:instance) { described_class.new(workflow, name, order, description: description) }
  let(:workflow) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:data) { workflow.data }

  let(:sections) { data[:sections] }
  let(:name) { 'Analysis' }
  let(:order) { 1 }
  let(:description) { 'Some section' }

  describe '#section' do
    context 'when section is created' do
      subject { sections.first }

      context 'when section is instantiated' do
        before { instance }

        it { is_expected.to include(name: 'Analysis', order: 1, steps: [], description: 'Some section') }
      end

      context 'when description is set via method' do
        before { instance.description('New description') }

        it { is_expected.to include(name: 'Analysis', order: 1, steps: [], description: 'New description') }
      end
    end

    context 'when step is added to section' do
      subject { sections.first[:steps] }

      before do
        instance.step('Generate Outline') do
          input :transcript
          prompt 'Analyze [transcript] and generate a preliminary outline for a blog post.'
          output :outline
        end
      end

      it {
        expect(subject).to include(
          name: 'Generate Outline',
          order: 1,
          description: nil,
          input_attributes: [:transcript],
          output_attributes: [:outline],
          prompt: 'Analyze [transcript] and generate a preliminary outline for a blog post.'
        )
      }
    end
  end
end
