#!/usr/bin/env ruby
#Encoding: UTF-8
require "test/unit"
require "xdo/keyboard.rb"
require "xdo/clipboard.rb"
require "xdo/xwindow"
require "xdo/simulatable"

class TestKeyboard < Test::Unit::TestCase
  
  #Command to start a simple text editor
  EDITOR_CMD = "gedit"
  TESTFILENAME = "#{ENV["HOME"]}/abcdefghijklmnopqrstuvwxyzäöüß.txt"
  TESTTEXT = "This is test\ntext."
  APPEND = "XYZ"
  TESTTEXT_RAW = "ä{TAB}?b"
  TESTTEXT_SPECIAL = "ab{TAB}c{TAB}{TAB}d"
  
  def self.startup
    File.open(TESTFILENAME, "w"){|file| file.write(TESTTEXT)}
    fork{system(%Q|#{EDITOR_CMD} "#{TESTFILENAME}"|)}
    sleep 5
  end
  
  def test_all
    XDo::Keyboard.simulate("{PGUP}")
    20.times{XDo::Keyboard.char("Shift+Right")}
    XDo::Keyboard.ctrl_c
    sleep 0.2
    assert_equal(TESTTEXT, XDo::Clipboard.read_clipboard)
    XDo::Keyboard.simulate("{RIGHT}#{APPEND}")
    XDo::Keyboard.ctrl_a
    XDo::Keyboard.ctrl_c
    sleep 0.2
    assert_equal(TESTTEXT + APPEND, XDo::Clipboard.read_clipboard)
    (TESTTEXT.length + APPEND.length + 2).times{XDo::Keyboard.simulate("\b")}
    XDo::Keyboard.simulate(TESTTEXT_RAW, true)
    sleep 0.2
    XDo::Keyboard.ctrl_a
    XDo::Keyboard.ctrl_c
    sleep 0.2
    assert_equal(TESTTEXT_RAW, XDo::Clipboard.read_clipboard)
    (TESTTEXT_RAW.length + 2).times{XDo::Keyboard.delete}
    XDo::Keyboard.simulate(TESTTEXT_SPECIAL)
    sleep 0.2
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
    clip = XDo::Keyboard.ctrl_c
    assert_equal("Ein String", clip)
  end
  
  def self.shutdown
    xwin = XDo::XWindow.from_name(EDITOR_CMD)
    xwin.activate
    XDo::Keyboard.ctrl_s
    sleep 0.5
    xwin.close
    File.delete(TESTFILENAME)
  end
  
end
