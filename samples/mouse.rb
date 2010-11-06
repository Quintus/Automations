#!/usr/bin/env ruby
#Encoding: UTF-8
#--
#This file is part of XDo. Copyright © 2009 Marvin Gülker
#XDo is published under Ruby's license. See http://www.ruby-lang.org/en/LICENSE.txt. 
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 
#++

=begin
This is an example on how to use the mouse with XDo::Mouse. 
=end

#Require the library
require "xdo/mouse"

#Get current cursor position
puts "Cursor X pos: #{XDo::Mouse.position[0]}"
puts "Cursor Y pos: #{XDo::Mouse.position[1]}"

#Move the mouse cursor
XDo::Mouse.move(10, 10)
#Click at the current position
XDo::Mouse.click
#Do a right-click at (100|100)
XDo::Mouse.click(100, 100, XDo::Mouse::RIGHT)
#Scroll down a text page
XDo::Mouse.wheel(XDo::Mouse::DOWN, 4)