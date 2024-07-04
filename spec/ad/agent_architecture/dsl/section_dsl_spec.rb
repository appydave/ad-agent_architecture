# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::SectionDsl do
  let(:instance) { described_class.new(workflow, name, order) }
  let(:workflow) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:data) { workflow.data }

  let(:sections) { data[:sections] }
  let(:name) { 'Analysis' }
  let(:order) { 1 }

  describe '#section' do
    context 'when step is instantiated' do
      subject { sections.first }

      before { instance }

      it { is_expected.to include(name: 'Analysis', order: 1, steps: []) }
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
        expect(subject).to include(name: 'Generate Outline', order: 1, input_attributes: [:transcript], output_attributes: [:outline],
                                   prompt: 'Analyze [transcript] and generate a preliminary outline for a blog post.')
      }
    end
  end
end
