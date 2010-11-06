#Encoding: UTF-8
#This file is part of au3. 
#Copyright © 2009, 2010 Marvin Gülker, Steven Heidel
#
#au3 is published under the same terms as Ruby. 
#See http://www.ruby-lang.org/en/LICENSE.txt

begin
  require_relative "../lib/au3"
  require_relative "../lib/AutoItX3/window/send_message"
rescue LoadError
  #Aha, this is the gem, not the build environment
  require "au3"
  require "AutoItX3/window/send_message"
end
require "test/unit"

class WindowCommandTest < Test::Unit::TestCase
  
  def self.startup
    AutoItX3.opt("WinTitleMatchMode", 2)
  end
  
  def setup
    AutoItX3.run("mspaint")
    sleep 1
    @win = AutoItX3::Window.new("Paint")
  end
  
  def test_send_message
    @win.send_message(:close)
    sleep 0.5
    assert(!@win.exists?)
  end
  
  def test_post_message
    @win.post_message(:close)
    sleep 0.5
    assert(!@win.exists?)
  end
  
end