# -*- coding: utf-8 -*-
gem "rdoc"

require "rake"
require "rdoc/task"

PROJECT_NAME = "Automations4win"

RDoc::Task.new do |r|
  r.title      = "#{PROJECT_NAME} RDocs"
  r.generator  = "hanna"
  r.rdoc_files = Dir["lib/**/*.rb"] + Dir["**/*.rdoc"]
  r.main       = "README.rdoc"
  r.rdoc_dir   = "doc"
end
