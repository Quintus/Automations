#Encoding: Windows-1252
#This file is part of au3. 
#Copyright (c) 2009 Marvin Gülker
begin
  require "../ext/au3" 
rescue LoadError
  #Aha, this is the gem, not the build environment
  require "au3"
end
require "test/unit"

class MouseTest < Test::Unit::TestCase
  
  THREADS = []
  
  def self.shutdown
    THREADS.each{|t| t.join}
  end
  
  def test_cursor_id
    pid = AutoItX3.run("notepad", "", AutoItX3::Window::SW_MAXIMIZE)
    AutoItX3.move_mouse(150, 150)
    THREADS << Thread.new{sleep 1;AutoItX3.kill_process(pid)}
    assert_equal(AutoItX3::IBEAM_CURSOR, AutoItX3.cursor_id)
  end
  
  def test_move_curpos
    AutoItX3.move_mouse(23, 74)
    assert_equal([23, 74], AutoItX3.cursor_pos)
  end
  
  def test_click
    pid = AutoItX3.run("notepad", "", AutoItX3::Window::SW_MAXIMIZE)
    AutoItX3.mouse_click(1000000, 5) #End of screen
    THREADS << Thread.new{sleep 1;AutoItX3.kill_process(pid)}
  end
  
  def test_tooltip
    assert_nil(AutoItX3.tooltip("Google is watching you!"))
    sleep 1
  end
  
end
