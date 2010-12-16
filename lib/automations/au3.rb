#Encoding: UTF-8
#This file is part of au3. 
#Copyright © 2009, 2010 Marvin Gülker, Steven Heidel
#
#au3 is published under the same terms as Ruby. 
#See http://www.ruby-lang.org/en/LICENSE.txt

require "ffi"

module Automations
  
  #Things specific to the Au3 part of Automations. 
  module Au3
    
  end
  
end

require_relative("./au3/keyboard")
require_relative("./au3/mouse")