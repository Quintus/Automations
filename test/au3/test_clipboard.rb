#Encoding: Windows-1252
#This file is part of au3. 
#Copyright (c) 2009 Marvin Gülker
begin
  require_relative "../lib/au3" 
rescue LoadError
  #Aha, this is the gem, not the build environment
  require "au3"
end
require "test/unit"

class ClipboardTest < Test::Unit::TestCase
  
  def test_clipboard
    AutoItX3.cliptext = "HDGDL"
    assert_equal("HDGDL", AutoItX3.cliptext)
  end
  
end