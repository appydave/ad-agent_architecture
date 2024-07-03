#!/usr/bin/env ruby
# frozen_string_literal: true

puts 'Watch Agent Workflow DSLs'

require 'pry'
require 'listen'

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'ad/agent_architecture'

directory_to_watch = File.expand_path('../spec/usecases', __dir__)

callback = proc do |modified, added, _removed|
  (modified + added).each do |file|
    if file.match(%r{spec/usecases/.+\.rbx$})
      # puts "Detected change in #{file}, running command..."
      load file
    end
  end
end

listener = Listen.to(directory_to_watch, &callback)
listener.start

puts "Listening for changes in #{directory_to_watch}..."

sleep
