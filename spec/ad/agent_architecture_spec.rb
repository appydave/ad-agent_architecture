# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture do
  it 'has a version number' do
    expect(Ad::AgentArchitecture::VERSION).not_to be_nil
  end

  it 'has a standard error' do
    expect { raise Ad::AgentArchitecture::Error, 'some message' }
      .to raise_error('some message')
  end
end
