# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::PromptDsl do
  let(:instance) { described_class.new(workflow) }
  let(:workflow) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:data) { workflow.data }

  context 'when adding prompt to worflow' do
    context 'when standard format' do
      subject { data[:prompts] }

      before do
        instance.prompt(:best_practice, content: 'Create 5 titles')
      end

      it { is_expected.to include(best_practice: { name: :best_practice, content: 'Create 5 titles', description: nil, path: nil }) }
    end

    context 'when prompt using block' do
      subject { data[:prompts] }

      before do
        instance.prompt(:best_practice) do
          content 'Create 5 titles'
          description 'This is a best practice'
        end
      end

      it { is_expected.to include(best_practice: { name: :best_practice, content: 'Create 5 titles', description: 'This is a best practice', path: nil }) }
    end

    context 'when using fluent interface' do
      subject { data[:prompts] }

      before do
        instance.prompt(:best_practice).content('Create 5 titles').description('This is a best practice')
      end

      it { is_expected.to include(best_practice: { name: :best_practice, content: 'Create 5 titles', description: 'This is a best practice', path: nil }) }
    end
  end

  context 'when prompt file is read' do
    let(:temp_dir) { Dir.mktmpdir }
    let(:prompt_file_path) { File.join(temp_dir, 'my_prompt.txt') }

    before do
      File.write(prompt_file_path, 'Create 5 titles')
      workflow.settings.prompt_path(temp_dir)
    end

    after do
      FileUtils.remove_entry temp_dir
    end

    it 'reads the content of the file' do
      expect(instance.load_file('my_prompt.txt').strip).to eq('Create 5 titles')
    end
  end
end
