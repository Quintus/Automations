#!/usr/bin/env ruby
#Encoding: UTF-8
gem "test-unit", ">= 2.1" #Ensure we use the gem
require "test/unit"
require "xdo/clipboard.rb"

class ClipboardTest < Test::Unit::TestCase
  
  def test_read
    #Write something to the clipboard first
    IO.popen("#{XDo::XSEL} -i", "w"){|io| io.write("Some primary test text")}
    IO.popen("#{XDo::XSEL} -b -i", "w"){|io| io.write("Some clipboard \ntest text")}
    IO.popen("#{XDo::XSEL} -s -i", "w"){|io| io.write("Some secondary test text")}
    
    clip = XDo::Clipboard.read
    assert_equal("Some primary test text", XDo::Clipboard.read_primary)
    assert_equal(XDo::Clipboard.read_primary, clip[:primary])
    assert_equal("Some clipboard \ntest text", XDo::Clipboard.read_clipboard)
    assert_equal(XDo::Clipboard.read_clipboard, clip[:clipboard])
    assert_equal("Some secondary test text", XDo::Clipboard.read_secondary)
    assert_equal(XDo::Clipboard.read_secondary, clip[:secondary])
  end
  
  def test_write
    XDo::Clipboard.write_primary "Primary!"
    XDo::Clipboard.write_clipboard "Clipboard!\nNewline"
    XDo::Clipboard.write_secondary "Secondary!"
    
    assert_equal("Primary!", `#{XDo::XSEL}`)
    assert_equal("Secondary!", `#{XDo::XSEL} -s`)
    assert_equal("Clipboard!\nNewline", `#{XDo::XSEL} -b`)
    
    XDo::Clipboard.write("XYZ", :primary, :secondary, :clipboard)
    assert_equal({primary: "XYZ", secondary: "XYZ", clipboard: "XYZ"}, XDo::Clipboard.read)
  end
  
  def test_append
    ["primary", "secondary", "clipboard"].each{|m| XDo::Clipboard.send(:"write_#{m}", "This is... ")}
    XDo::Clipboard.append("a Test!", :primary, :secondary, :clipboard)
    ["primary", "secondary", "clipboard"].each{|m| assert_equal(XDo::Clipboard.send(:"read_#{m}"), "This is... a Test!")}
  end
  
  def test_clear
    XDo::Clipboard.write("ABC", :primary, :secondary, :clipboard)
    ["primary", "secondary", "clipboard"].each{|m| XDo::Clipboard.send("clear_#{m}")}
    ["primary", "secondary", "clipboard"].each{|m| assert_equal("", XDo::Clipboard.send("read_#{m}"))}
  end
  
end
