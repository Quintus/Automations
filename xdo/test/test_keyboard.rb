#!/usr/bin/env ruby
#Encoding: UTF-8
gem "test-unit", ">= 2.1" #Ensure we use the gem
require "test/unit"
require "tempfile"
require "xdo/keyboard.rb"
require "xdo/clipboard.rb"
require "xdo/xwindow"
require "xdo/simulatable"

class TestKeyboard < Test::Unit::TestCase
  
  #Command to start a simple text editor
  EDITOR_CMD = "gedit"
  
  TESTTEXT = "This is test\ntext."
  TESTTEXT2 = "XYZ"
  TESTTEXT_RAW = "ä{TAB}?b"
  TESTTEXT_SPECIAL = "ab{TAB}c{TAB}{TAB}d"
  
  def setup
    @edit_pid = spawn(EDITOR_CMD)
    sleep 0.5
  end
  
  def teardown
    Process.kill("KILL", @edit_pid)
  end
  
  def test_char
    Process.kill("KILL", @edit_pid) #Special file need to be opened
    tempfile = Tempfile.open("XDOTEST")
    tempfile.write(TESTTEXT)
    tempfile.flush
    sleep 1 #Wait for the buffer to be written out
    @edit_pid = spawn(EDITOR_CMD, tempfile.path) #So it's automatically killed by #teardown
    sleep 1
    tempfile.close
    20.times{XDo::Keyboard.char("Shift+Right")}
    XDo::Keyboard.ctrl_c
    sleep 0.2
    assert_equal(TESTTEXT, XDo::Clipboard.read_clipboard)
  end
  
  def test_simulate
    XDo::Keyboard.simulate("A{BS}#{TESTTEXT2}")
    XDo::Keyboard.ctrl_a
    XDo::Keyboard.ctrl_c
    sleep 0.2
    assert_equal(TESTTEXT2, XDo::Clipboard.read_clipboard)
    
    XDo::Keyboard.ctrl_a
    XDo::Keyboard.delete
    XDo::Keyboard.simulate(TESTTEXT_SPECIAL)
    XDo::Keyboard.ctrl_a
    XDo::Keyboard.ctrl_c
    sleep 0.2
    assert_equal(TESTTEXT_SPECIAL.gsub("{TAB}", "\t"), XDo::Clipboard.read_clipboard)
    
    XDo::Keyboard.ctrl_a
    XDo::Keyboard.delete
    XDo::Keyboard.simulate(TESTTEXT_RAW, true)
    XDo::Keyboard.ctrl_a
    XDo::Keyboard.ctrl_c
    sleep 0.2
    assert_equal(TESTTEXT_RAW, XDo::Clipboard.read_clipboard)
  end
  
  def test_type
    XDo::Keyboard.type(TESTTEXT2)
    XDo::Keyboard.ctrl_a
    XDo::Keyboard.ctrl_c
    sleep 0.2
    assert_equal(TESTTEXT2, XDo::Clipboard.read_clipboard)
  end
  
  def test_window_id
    XDo::XWindow.focus_desktop #Ensure that the editor hasn't the input focus anymore
    sleep 1
    edit_id = XDo::XWindow.search(EDITOR_CMD).first
    xwin = XDo::XWindow.new(edit_id)
    XDo::Keyboard.simulate(TESTTEXT_SPECIAL, false, edit_id)
    sleep 1
    xwin.activate
    XDo::Keyboard.ctrl_a
    XDo::Keyboard.ctrl_c
    sleep 0.2
    assert_equal(TESTTEXT_SPECIAL.gsub("{TAB}", "\t"), XDo::Clipboard.read_clipboard)
  end
  
  def test_include
    String.class_eval do
      include XDo::Simulatable
      
      def to_xdo
        to_s
      end
    end
    
    XDo::Keyboard.ctrl_a
    XDo::Keyboard.delete
    "Ein String".simulate
    XDo::Keyboard.ctrl_a
    sleep 0.2
    XDo::Keyboard.ctrl_c
    sleep 0.2
    clip = XDo::Clipboard.read_clipboard
    assert_equal("Ein String", clip)
  end
  
end
