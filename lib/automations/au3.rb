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
    
    #Converts +str+ to a MS API-compliant wide string. 
    def self.wide_str(str)
      "#{str}\0".force_encoding("UTF-16LE")
    end
    
    #Converts +str+ from an MS API-compliant wide string back to 
    #a normal Ruby UTF-8-encoded string. 
    def self.unwide_str(str)
      str.encode("UTF-8").strip
    end
    
  end
  
end

require_relative("./au3/structs")
require_relative("./au3/functions")

#require_relative("./au3/keyboard")
require_relative("./au3/mouse")