# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::PromptDsl do
  let(:instance) { described_class.new(workflow) }
  let(:workflow) { Ad::AgentArchitecture::Dsl::WorkflowDsl.new('Name') }
  let(:data) { workflow.data }

  context 'when prompts are added to workflow' do
    subject { data[:prompts] }

    before do
      instance.prompt(:best_practice, content: 'Create 5 titles')
    end

    it { is_expected.to include(best_practice: { name: :best_practice, content: 'Create 5 titles' }) }
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
      expect(instance.prompt_file('my_prompt.txt').strip).to eq('Create 5 titles')
    end
  end
end
