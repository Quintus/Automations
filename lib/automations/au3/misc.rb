#Encoding: UTF-8
#This file is part of au3. 
#Copyright © 2009, 2010 Marvin Gülker, Steven Heidel
#
#au3 is published under the same terms as Ruby. 
#See http://www.ruby-lang.org/en/LICENSE.txt

module Automations
  
  module AutoItX3
    
    class << self
      
      #Blocks user input. 
      #===Parameters
      #[+val+] Wheather the user input should be blocked or not. 
      #===Return value
      #The passed argument, double-negated to ensure a boolean value. 
      #===Example
      #  p AutoItX3.input_blocked? #=> false
      #  AutoItX3.block_input = true
      #  p AutoItX3.input_blocked? #=> true
      #  AutoItX3.block_input = false
      #  p AutoItX3.input_blocked? #=> false
      #===Remarks
      #The user can gain back control by pressing [CTRL] + [ALT] + [DEL]. 
      #In older versions of Windows AutoIt itself may also be blocked. 
      def block_input=(val)
        @functions[__method__] ||= AU3_Function.new("BlockInput", 'L')
        @functions[__method__].call(!!val)
        @input_blocked = !!val
      end
      
      #Returns wheather or not input is blocked by AutoItX3. 
      #===Return value
      #true or false. 
      #===Example
      #  #See #block_input. 
      #===Remarks
      #This method fails to report that input has been enabled again if the 
      #user has pressed [CTRL] + [ALT] + [DEL] after a call to #block_input=. 
      def input_blocked?
        @input_blocked ||= false
      end
      
      #Opens a CD/DVD drive. 
      #===Parameters
      #[+tray+] The drive to eject, a string of form <tt>"X:"</tt>. 
      #===Return value
      #true on success, false otherwise. 
      #===Example
      #  AutoItX3.open_cd_tray("E:") #| true
      #  AutoItX3.open_cd_tray("Y:") #| false
      #===Remarks
      #The cd tray must be local at this computer, remote drives 
      #cannot be accessed. 
      def open_cd_tray(tray)
        @functions[__method__] ||= AU3_Function.new("CDTray", 'SS', 'L')
        raise(ArgumentError, "The drive name has to be of form 'X:'!") unless tray =~ /^\w:$/
        @functions[__method__].call(tray.wide, "open".wide) == 1
      end
      
      #Closes a CD/DVD drive. 
      #===Parameters
      #[+tray+] The drive to close. 
      #===Return value
      #true on success, false otherwise. 
      #===Example
      #  AutoItX3.open_cd_tray("E:")
      #  AutoItX3.close_cd_tray("E:")
      #===Remarks
      #The cd tray must be local at this computer, remote drives 
      #cannot be accessed. 
      #This method may return true if +drive+ is a laptop drive which can only be 
      #closed manually. 
      def close_cd_tray(tray)
        @functions[__method__] ||= AU3_Function.new("CDTray", 'SS', 'L')
        raise(ArgumentError, "The drive name has to be of form 'X:'!") unless tray =~ /^\w:$/
        @functions[__method__].call(tray.wide, "closed".wide) == 1
      end
      
      #Determines wheather the current user has administrator privileges. 
      #===Return value
      #true or false, 
      #===Example
      #  p AutoItX3.is_admin? #=> false
      def is_admin?
        @functions[__method__] ||= AU3_Function.new("IsAdmin", 'V', 'L')
        @functions[__method__].call == 1
      end
      
      #Writes +text+ to the Windows clipboard. 
      #===Parameters
      #[+text+] The text to write. 
      #===Return value
      #The argument passed. 
      #===Example
      #  AutoItX3.cliptext = "I love Ruby!"
      #  puts AutoItX3.cliptext #=> I love Ruby!
      #===Remarks
      #You can't write NUL characters to the clipboard, the text will 
      #be terminated. 
      def cliptext=(text)
        @functions[__method__] ||= AU3_Function.new("ClipPut", 'S')
        @functions[__method__].call(text.wide)
        text
      end
      
      #Reads the Windows clipboard. 
      #===Return value
      #The text saved in the clipboard, encoded in UTF-8. 
      #===Example
      #  puts AutoItX3.cliptext #=> I love Ruby!
      #===Remarks
      #Returns the text saved in the clipboard. It will be truncated at the 
      #<tt>AutoItX3::BUFFER_SIZE - 1</tt>th character or at a NUL character. 
      #
      #If the clipboard doesn't contain text, this method returns an empty string. 
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
      #Displays a tooltip at the given position. 
      #===Parameters
      #[+text+] The text to display. 
      #[+x+] (+INTDEFAULT+) The X coordinate where to display the tooltip. Defaults to the cursor's X coordinate if ommited. 
      #[+y+] (+INTDEFAULT+) The Y coordinate where to display the tooltip. Defaults to the cursor's Y coordinate if ommited. 
      #===Return value
      #nil. 
      #===Remarks
      #Coordinates out of range are automatically corrected. 
      #
      #The tooltip will be deleted when the program ends, or after a system-dependent 
      #timeout. 
      def tool_tip(text, x = INTDEFAULT, y = INTDEFAULT)
        @functions[__method__] ||= AU3_Function.new("ToolTip", 'SLL')
        @functions[__method__].call(text.wide, x, y)
      end
      alias tooltip tool_tip
      
      #Wait for the specified amount of milliseconds. 
      #===Return value
      #nil. 
      #===Remarks
      #In AutoIt, this function is named "Sleep", but to avoid compatibility 
      #issues with Ruby's own sleep I decided to 
      #name the function "msleep" (the "m" indicates "milli"). If you wish to name it 
      #"sleep", simply define an alias. 
      def msleep(msecs)
        @functions[__method__] ||= AU3_Function.new("Sleep", 'L')
        @functions[__method__].call(msecs)
      end
      
    end #au3single
    
  end #AutoItX3
  
end
