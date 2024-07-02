# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::StepDsl do
  let(:instance) { described_class.new(workflow, section, name, order) }
  let(:section) { workflow[:sections].first }
  let(:steps) { section[:steps] }
  let(:name) { 'Generate Outline' }
  let(:order) { 1 }
  let(:dsl) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:workflow) { dsl.workflow }

  before do
    dsl.section('Section Name')
  end

  describe '#step' do
    context 'when step is instantiated' do
      subject { steps.first }

      before { instance }

      it { is_expected.to include(name: 'Generate Outline', order: 1, input_attributes: [], output_attributes: [], prompt: '') }
    end

    context 'when input is added to step' do
      subject { steps.first[:input_attributes] }

      before do
        instance.input :transcript
      end

      it { is_expected.to include(:transcript) }
    end

    context 'when output is added to step' do
      subject { steps.first[:output_attributes] }

      before do
        instance.output :outline
      end

      it { is_expected.to include(:outline) }
    end

    context 'when prompt is added to step' do
      subject { steps.first[:prompt] }

      before do
        instance.prompt 'Analyze [transcript] and generate a preliminary outline for a blog post.'
      end

      it { is_expected.to eq('Analyze [transcript] and generate a preliminary outline for a blog post.') }
    end
  end
end
