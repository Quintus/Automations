#!/bin/env ruby
#Encoding: UTF-8

module Automations
  
  module Au3
    
    module Functions
      extend FFI::Library
      
      ffi_lib "AutoItX3"
      
      attach_function :AU3_MouseClick, [:buffer_in, :long, :long, :long, :long], :long
      attach_function :AU3_MouseClickDrag, [:buffer_in, [:long] * 5].flatten, :long
      attach_function :AU3_MouseDown, [:buffer_in], :void
      attach_function :AU3_MouseGetCursor, [], :long
      attach_function :AU3_MouseGetPosX, [], :long
      attach_function :AU3_MouseGetPosY, [], :long
      attach_function :AU3_MouseMove, [:long] * 3, :long
      attach_function :AU3_MouseUp, [:buffer_in], :void
      attach_function :AU3_MouseWheel, [:buffer_in, :long], :void
      
      #Ruby doesn't like method names beginning with an uppercase letter. 
      #If this module is included, you can't just type
      #  AU3_MouseClick(...)
      #and you're done. You would have to type: 
      #  self.AU3_MouseClick(...)
      #method_missing allows you to type 
      #  mouse_click
      #instead. 
      def self.method_missing(sym, *args, &block)
        sym2 = :"AU3_#{sym.to_s.split("_").map(&:capitalize).join}"
        p sym2
        if respond_to? sym2
          send(sym2, *args, &block)
        else
          super
        end
      end
      
      def method_missing(sym, *args, &block)
        Automations::Au3::Functions.send(sym, *args, &block)
      end
      
    end
    
  end
  
end
