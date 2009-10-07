#Encoding: UTF-8
#This file is part of au3. 
#Copyright © 2009 Marvin Gülker
#
#au3 is published under the same terms as Ruby. 
#See http://www.ruby-lang.org/en/LICENSE.txt

module AutoItX3
  
  class << self
    
    #Blocks user input or enables it (but the user can gain back control by 
    #pressing [CTRL] + [ALT] + [DEL]). In older versions of Windows, 
    #AutoIt may also be blocked. Does not work with Windows Vista. 
    def block_input=(val)
      @functions[__method__] ||= AU3_Function.new("BlockInput", 'L')
      @functions[__method__].call(!!val)
      @input_blocked = !!val
    end
    
    #Returns wheather or not input is blocked by AutoItX3. 
    def input_blocked?
      @input_blocked ||= false
    end
    
    #Opens the cd drive named in +drive+. +drive+ should be of form 
    #<tt>"X:"</tt>. The cd tray must be local at this computer, remote drives 
    #cannot be accessed. 
    def open_cd_tray(tray)
      @functions[__method__] ||= AU3_Function.new("CDTray", 'SS', 'L')
      raise(ArgumentError, "The drive name has to be of form 'X:'!") unless tray =~ /^\w:$/
      if @functions[__method__].call(tray.wide, "open".wide) == 0
        return false
      else
        return true
      end
    end
    
    #Closes a cd tray. +drive+ should be of form <tt>"X:"</tt>. The cd tray must 
    #be local at this computer, remote drives cannot be accessed. 
    #The method may return true if +drive+ is a laptop drive which can only be 
    #closed manually. 
    def close_cd_tray(tray)
      @functions[__method__] ||= AU3_Function.new("CDTray", 'SS', 'L')
      raise(ArgumentError, "The drive name has to be of form 'X:'!") unless tray =~ /^\w:$/
      if @functions[__method__].call(tray.wide, "closed".wide) == 0
        return false
      else
        return true
      end
    end
    
    #Determines wheather the current user has administrator privileges. 
    def is_admin?
      @functions[__method__] ||= AU3_Function.new("IsAdmin", 'V', 'L')
      return false if @functions[__method__].call == 0
      true
    end
    
    #Writes +text+ to the Windows clipboard. 
    #You can't write NUL characters to the clipboard, the text will 
    #be terminated. 
    def cliptext=(text)
      @functions[__method__] ||= AU3_Function.new("ClipPut", 'S')
      @functions[__method__].call(text.wide)
      text
    end
    
    #Returns the text saved in the clipboard. It will be truncated at the 99,999th character or 
    #at a NUL char. 
    def cliptext
      @functions[__method__] ||= AU3_Function.new("ClipGet", 'PL')
      cliptext = " " * BUFFER_SIZE
      cliptext.wide!
      @functions[__method__].call(cliptext, cliptext.size - 1)
      cliptext.normal.strip
    end
    
    #call-seq: 
    #  tool_tip( text [, x = INTDEFAULT [, y = INTDEFAULT ] ] ) ==> nil
    #  tooltip( text [, x = INTDEFAULT [, y = INTDEFAULT ] ] ) ==> nil
    #
    #Displays a tooltip at the given position. If +x+ and +y+ are ommited, 
    #the tooltip will be displayed at the current cursor position. Coordinates 
    #out of range are automatically corrected. 
    #The tooltip will be deleted when the program ends, or after a system-dependent 
    #timeout. 
    def tool_tip(text, x = INTDEFAULT, y = INTDEFAULT)
      @functions[__method__] ||= AU3_Function.new("ToolTip", 'SLL')
      @functions[__method__].call(text.wide, x, y)
    end
    alias tooltip tool_tip
    
    #Wait for the specified amount of milliseconds. In AutoIt, this function is named 
    #"Sleep", but to avoid compatibility issues with Ruby's own sleep I decided to 
    #name the function "msleep" (the "m" indicates "milli"). If you wish to name it 
    #"sleep", simply define an alias. 
    def msleep(msecs)
      @functions[__method__] ||= AU3_Function.new("Sleep", 'L')
      @functions[__method__].call(msecs)
    end
    
  end #au3single
  
end #AutoItX3