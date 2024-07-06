# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Ad::AgentArchitecture::Dsl::Actions::SaveJson do
  let(:some_hash) do
    {
      name: 'Test Workflow',
      attributes: { title: { name: :title, type: :string, is_array: false } },
      sections: []
    }
  end
  let(:instance) { described_class.new(some_hash) }
  let(:file_name) { 'workflow.json' }

  describe '#save' do
    before do
      allow(File).to receive(:write)
    end

    it 'saves the workflow to a JSON file' do
      instance.save(file_name)
      expect(File).to have_received(:write).with(file_name, JSON.pretty_generate(some_hash))
    end
  end
end
