# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::StepDsl do
  let(:instance) { described_class.new(workflow, section, name, order) }
  let(:workflow) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:data) { workflow.data }

  let(:section) { data[:sections].first }
  let(:steps) { section[:steps] }
  let(:name) { 'Generate Outline' }
  let(:order) { 1 }

  before do
    workflow.section('Section Name')
  end

  describe '#step' do
    context 'when step is instantiated' do
      subject { instance.step }

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

      context 'when prompt is not in defined prompts' do
        before do
          instance.prompt 'Analyze [transcript] and generate a preliminary outline for a blog post.'
        end

        it { is_expected.to eq('Analyze [transcript] and generate a preliminary outline for a blog post.') }
      end

      context 'when prompt is in defined prompts' do
        subject { steps.first[:prompt] }

        before do
          instance.prompts[:some_prompt] = 'Analyze [transcript] and generate a preliminary outline for a blog post.'
          instance.prompt :some_prompt
        end

        it { is_expected.to eq('Analyze [transcript] and generate a preliminary outline for a blog post.') }
      end
    end
  end

  describe '#infer_attribute' do
    subject { data[:attributes] }

    context 'when infer_attribute is called for new attributes' do
      context 'when infer_attribute has not been called' do
        it 'does not infer the type for new attributes' do
          expect(subject).to be_empty
        end
      end

      context 'when infer_attribute is called for array attribute' do
        before do
          instance.send(:infer_attribute, :tags)
        end

        it 'infers the type for new attributes' do
          expect(subject).to include(
            tags: { name: :tags, type: 'array', is_array: true }
          )
        end
      end

      context 'when infer_attribute is called for string attribute' do
        before do
          instance.send(:infer_attribute, :description)
        end

        it 'infers the type for new attributes' do
          expect(subject).to include(
            description: { name: :description, type: 'string', is_array: false }
          )
        end
      end
    end

    context 'when infer_attribute is called for existing attributes' do
      before do
        data[:attributes][:items] = { name: :description, type: :text, is_array: false }
        instance.send(:infer_attribute, :description)
      end

      it 'does not override existing attributes' do
        expect(subject[:items]).to include(name: :description, type: :text, is_array: false)
      end
    end
  end
end
