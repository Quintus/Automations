#Encoding: UTF-8
#This file is part of au3. 
#Copyright (c) 2009 Marvin Gülker
begin
  require_relative "../lib/au3"
rescue LoadError
  #Aha, this is the gem, not the build environment
  require "au3"
end
require "test/unit"

class MiscTest < Test::Unit::TestCase
  
  TEST_TRAY = "E:"
  
  def test_cd_open
    assert(AutoItX3.open_cd_tray(TEST_TRAY))
  end
  
  def test_cd_close
    AutoItX3.open_cd_tray(TEST_TRAY)
    if !AutoItX3.close_cd_tray(TEST_TRAY)
      notify "Could not close your CD tray. Are you running on a laptop?"
    else
      assert(true)
    end
  end
  
  def test_sleep
    than = Time.now
    AutoItX3.msleep(1000)
    now = Time.now
    assert_in_delta(1.0, now - than, 0.01)
  end
  
end
