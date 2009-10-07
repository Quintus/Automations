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

class KeyboardTest < Test::Unit::TestCase
  
  TEXT1 = "abc"
  TEXT2 = "One with\nNewline"
  TEXT3 = "With{TAB}tab"
  
  def setup
    @pid = AutoItX3.run("notepad", "", AutoItX3::Window::SW_MAXIMIZE)
    sleep 2
    AutoItX3.mouse_click(150, 150)
  end
  
  def teardown
    AutoItX3.kill_process(@pid)
    sleep 1
  end
  
  def copy_all
    AutoItX3.send_keys("^a")
    AutoItX3.msleep(200)
    AutoItX3.send_keys("^c")
    AutoItX3.msleep(200)
  end
  
  def delete_all
    AutoItX3.send_keys("^a")
    AutoItX3.msleep(200)
    AutoItX3.send_keys("{BS}")
    AutoItX3.msleep(200)
  end
  
  def test_send
    AutoItX3.send_keys(TEXT1)
    copy_all
    assert_equal(TEXT1, AutoItX3.cliptext)
    delete_all
    AutoItX3.send_keys(TEXT2)
    copy_all
    assert_equal(TEXT2, AutoItX3.cliptext)
    delete_all
    AutoItX3.send_keys(TEXT3)
    copy_all
    assert_equal(TEXT3.sub("{TAB}", "\t"), AutoItX3.cliptext)
    delete_all
    AutoItX3.send_keys(TEXT3, true)
    copy_all
    assert_equal(TEXT3, AutoItX3.cliptext)
  end
  
end