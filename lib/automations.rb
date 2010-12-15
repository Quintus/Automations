#!/usr/bin/env ruby
#Encoding: UTF-8
#This file is part of Automations. 
#Copyright © 2010 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 

require "pathname"

#Main module that is needed by everything else. 
module Automations
  
  #The version of this library. 
  VERSION = Pathname.new(__FILE__).dirname.expand_path.parent.join("VERSION").read.chomp.freeze
  
end

#Require the platform-specific library or raise an error 
#if the target platform isn't supported. 
case RUBY_PLATFORM
when /linux/ then require_relative "automations/linux"
when /mswin|mingw|cygwin/ then require_relative "automations/windows"
else
  raise(NotImplementedError, "We're sorry, but the platform #{RUBY_PLATFORM} isn't supported by Automations yet.")
end
