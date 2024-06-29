# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe Ad::AgentArchitecture::Dsl::Actions::SaveYaml do
  let(:workflow_hash) do
    {
      name: 'Test Workflow',
      attributes: { title: { name: :title, type: :string, is_array: false } },
      sections: []
    }
  end
  let(:instance) { described_class.new(workflow_hash) }
  let(:file_name) { 'workflow.yaml' }

  describe '#save' do
    before do
      allow(File).to receive(:write)
    end

    it 'saves the workflow to a YAML file' do
      instance.save(file_name)
      expect(File).to have_received(:write).with(file_name, workflow_hash.to_yaml)
    end
  end
end
