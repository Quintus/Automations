#Encoding: UTF-8
#This file is part of Xdo. 
#Copyright © 2009 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 
require "rake/gempackagetask"
require "rake/rdoctask"
require "rake/testtask"

spec = Gem::Specification.new do |s|
  s.name = "xdo"
  s.summary = "Simulate keyboard and mouse input via a ruby interface to xdotool and other console programs."
  s.description =<<DESCRIPTION
XDo is a library to automate your mouse, fake keyboard input and 
manipulate windows in a Linux X server environment. It's wrapped 
around a lot of command line tools (see requirements) of which xdotool 
is the main one, the others are usually installed. 
DESCRIPTION
  s.add_dependency("test-unit", ">= 2.0")
  s.requirements = ["The xdotool command-line tool.", "xwininfo (usually installed)", "The xsel command-line tool.", "eject (usually installed)", "xkill (usually installed)"]
  s.requirements << "The unit-test gem (will be installed if you don't have it)"
  s.version = "0.0.1"
  s.author = "Marvin Gülker"
  s.email = "sutniuq@gmx.net"
  s.platform = Gem::Platform::CURRENT
  s.required_ruby_version = ">=1.9"
  s.files = ["bin/xinfo.rb", Dir["lib/**/*.rb"], Dir["test/*.rb"], Dir["samples/*.rb"], "Rakefile", "lib/README.rdoc"].flatten
  s.executables = ["xinfo.rb"]
  s.has_rdoc = true
  s.test_files = Dir["test/test_*.rb"]
  s.rubyforge_project = "Automations"
end
Rake::GemPackageTask.new(spec).define

Rake::RDocTask.new do |rd|
  rd.rdoc_files.include("lib/**/*.rb", "lib/README.rdoc")
  rd.title = "xdo RDocs"
  rd.main = "lib/README.rdoc"
end

Rake::TestTask.new("test") do |t|
  t.pattern = "test/test_*.rb"
  t.warning = true
end

desc "Tests XDo and then builds the gem file."
task :full_gem => [:test, :gem]