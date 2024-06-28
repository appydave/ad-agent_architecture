# frozen_string_literal: true

require_relative 'lib/ad/agent_architecture/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version  = '>= 3.0'
  spec.name                   = 'ad-agent_architecture'
  spec.version                = Ad::AgentArchitecture::VERSION
  spec.authors                = ['David Cruwys']
  spec.email                  = ['david@ideasmen.com.au']

  spec.summary                = 'Architecture/Schema for AI Agents'
  spec.description            = <<-TEXT
    Architecture/Schema for AI Agents
  TEXT
  spec.homepage               = 'http://appydave.com/gems/ad-agent_architecture'
  spec.license                = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  # spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri']           = spec.homepage
  spec.metadata['source_code_uri']        = 'https://github.com/appydave/ad-agent_architecture'
  spec.metadata['changelog_uri']          = 'https://github.com/appydave/ad-agent_architecture/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required']  = 'true'

  # The `git ls-files -z` loads the RubyGem files that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  # spec.extensions    = ['ext/ad_agent_architecture/extconf.rb']

  spec.add_dependency 'k_log', '~> 0'
  spec.add_dependency 'sequel', '~> 5'
  spec.add_dependency 'sqlite3', '~> 2'
end
