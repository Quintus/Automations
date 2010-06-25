#Encoding: UTF-8
#This file is part of Xdo. 
#Copyright © 2009, 2010 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 
require_relative("../xdo")
require_relative("../small_scanner")

module XDo
  
  #A namespace encabsulating methods to simulate keyboard input. You can 
  #send input to special windows, use the +w_id+ parameter of many methods 
  #for that purpose. 
  #NOTE: xdotool seams to reject the <tt>--window</tt> option even if you try 
  #to run it directly. This command fails (where 60817411 is a window id): 
  #  xdotool key --window 60817411 a
  #So don't be surprised if it does not work with this library. Hopefully this will be 
  #fixed, so I leave this in. 
  module Keyboard
    
    ALIASES = {
      "BS" => "BackSpace", 
      "BACKSPACE" => "BackSpace", 
      "DEL" => "Delete", 
      "ESC" => "Escape", 
      "INS" => "Insert", 
      "PGUP" => "Prior", 
      "PGDN" => "Next", 
      "NUM1" => "KP_End", 
      "NUM2" => "KP_Down", 
      "NUM3" => "KP_Next", 
      "NUM4" => "KP_Left", 
      "NUM5" => "KP_Begin", 
      "NUM6" => "KP_Right", 
      "NUM7" => "KP_Home", 
      "NUM8" => "KP_Up", 
      "NUM9" => "KP_Prior", 
      "NUM_DIV" => "KP_Divide", 
      "NUM_MUL" => "KP_Multiply", 
      "NUM_SUB" => "KP_Subtract", 
      "NUM_ADD" => "KP_Add", 
      "NUM_ENTER" => "KP_Enter", 
      "NUM_DEL" => "KP_Delete", 
      "NUM_COMMA" => "KP_Separator", 
      "NUM_INS" => "KP_Insert", 
      "NUM0" => "KP_0", 
    }.freeze
    
    SPECIAL_CHARS = {
      "ä" => "adiaeresis", 
      "Ä" => "Adiaeresis", 
      "ö" => "odiaeresis", 
      "Ö" => "Odiaeresis", 
      "ü" => "udiaeresis", 
      "Ü" => "Udiaeresis", 
      "ë" => "ediaeresis", 
      "Ë" => "Ediaeresis", #Does not work with xdotool
      "ï" => "idiaeresis", 
      "Ï" => "Idiaeresis", #Does not work with xdotool
      "ß" => "ssharp", 
      "\n" => "Return", 
      "\t" => "Tab", 
      "\b" => "BackSpace", 
      "§" => "section", 
      "[" => "bracketleft", 
      "]" => "bracketright", 
      "{" => "braceright", 
      "}" => "braceleft", 
      "@" => "at", 
      "€" => "EuroSign", 
      "|" => "bar"
    }
    
    class << self
      
      #Types a character sequence, but without any special chars. 
      #This function is a bit faster then #simulate. 
      def type(str, w_id = nil)
        out = `#{XDOTOOL} type #{w_id ? "--window #{w_id} " : ""}'#{str}'`
        nil
      end
      
      #Types a character sequence. You can use the escape sequence {...} to send special 
      #keystrokes, a full list of supported keystrokes is printed out by: 
      #  puts (XDo::Keyboard.constants - [:SPECIAL_CHARS])
      #This method recognizes many special chars like ? and ä, even if you disable 
      #the escape syntax {..} via setting the +raw+ parameter to true (that's the only way to send the { and } chars). 
      #It's a bit slower than the #type method. 
      def simulate(str, raw = false, w_id = nil)
        raise(XDo::XError, "Invalid number of open and close braces!") unless str.scan(/{/).size == str.scan(/}/).size
        
        tokens = tokenize(str)
        
        tokens.each do |sym, s|
          case sym
            when :plain then type(s, w_id)
            when :esc then 
              if raw
                type("{#{s}}", w_id) #The braces should be preserved when using +raw+. 
              else
                if ALIASES.has_key?(s)
                  key(ALIASES[s]) 
                else
                  char(s.split("_").map(&:capitalize).join("_"), w_id)
                end
              end
            when :special then
              if SPECIAL_CHARS.has_key?(s)
                char(SPECIAL_CHARS[s], w_id)
              else
                raise(XDo::ParseError, "No key symbol known for '#{s}'!")
              end
          else #Write a bug report if you get here. That really shouldn't happen. 
            raise(XDo::ParseError, "Invalid token named #{sym.inspect}! This is an internal error - please write a bug report at http://github.com/Quintus/Automations/issues or email me at sutniuq@@gmx@net.")
          end
        end
        str
      end
      
      #Simulate a single char directly via the +key+ function of +xdotool+. 
      #+c+ is a single char like "a" or a combination like "shift+a". 
      def char(c, w_id = nil)
        Open3.popen3("#{XDOTOOL} key #{w_id ? "--window #{w_id} " : ""}#{c}") do |stdin, stdout, stderr|
          stdin.close_write
          raise(XDo::XError, "Invalid character '#{c}'!") if stderr.read =~ /No such key name/
        end
      end
      alias key char
      
      #Holds a key down. Please call #key_up after a call to this method. 
      def  key_down(key, w_id = nil)
        `#{XDOTOOL} keydown #{w_id ? "--window #{w_id} " : "" }#{check_for_special_key(key)}`
      end
      
      #Releases a key hold down by #key_down. 
      def key_up(key, w_id = nil)
        `#{XDOTOOL} keyup #{w_id ? "--window #{w_id} " : "" }#{check_for_special_key(key)}`
      end
      
      #Deletes a char. If +right+ is true, +del_char+ uses 
      #the DEL key for deletion, otherwise the BackSpace key. 
      def delete(right = false)
        Keyboard.simulate(right ? "\b" : "{DEL}")
      end
      
      #Allows you to things like this: 
      #  XDo::Keyboard.ctrl_c
      #The string will be capitalized and every _ will be replaced by a + and then passed into #char. 
      #You can't use this way to send whitespace or _ characters. 
      def method_missing(sym, *args, &block)
        super if args.size > 1 or block
        char(sym.to_s.capitalize.gsub("_", "+"), args[0])
      end
      
      private
      
      def tokenize(str)
        tokens = []
        ss = SmallScanner.new(str)
        until ss.eos?
          pos = ss.pos
          if ss.scan_until(/{/)
            #Get the string between the last and the recent match. We have to subtract 2 here, 
            #since a SmallScanner position is always ahead of the stirng character by 1 (since 0 in 
            #a SmallScanner means "before the first character") and the matched brace shouldn't be 
            #included. 
            tokens << [:plain, ss.string[Range.new(pos, ss.pos - 2)]] unless ss.pos == 1 #This means, the escape sequence is at the beginning of the string - no :plain text before. 
            pos = ss.pos
            ss.scan_until(/}/)
            tokens << [:esc, ss.string[Range.new(pos, ss.pos - 2)]] #See above for comment on -2
          else #We're behind the last escape sequence now - there must be some characters left, otherwise this would be triggered. 
            tokens << [:plain, ss.rest]
            ss.terminate
          end
        end
        #Now hunt for special character like ä which can't be send using xdotool's type command. 
        regexp = Regexp.union(*SPECIAL_CHARS.keys.map{|st| Regexp.escape(st)})
        tokens.map! do |ary|
          next([ary]) unless ary[0] == :plain #Extra array since we flatten(1) it afterwards
          tokens2 = []
          ss = SmallScanner.new(ary[1])
          until ss.eos?
            pos = ss.pos
            if ss.scan_until(regexp)
              tokens2 << [:plain, ss.string[Range.new(pos, ss.pos - 2)]] unless ss.pos == 1
              tokens2 << [:special, ss.matched]
              pos = ss.pos
            else
              tokens2 << [:plain, ss.rest]
              ss.terminate
            end
          end
          tokens2
        end
        #Make the token sequence 1-dimensional
        tokens.flatten!(1)
        #Now delete empty :plain tokens, they don't have to be handled. 
        #They are created by strings like "abc{ESC}{ESC}", where they are 
        #recognized between the two escapes. 
        #Empty escape sequences are an error in any case. 
        tokens.delete_if do |sym, st|
          if st.empty?
            if sym == :esc
              raise(XDo::ParseError, "Empty escape sequence found!")
            else
              true
            end
          end
        end
        
        #Return the tokens array. 
        tokens
      end
      
      #Wraps an escape sequenz in the corerresponding class and 
      #returns the commands needed to execute it. 
      def sequence_escape(token, w_id)
        esc = XDo::Keyboard.const_get(token.upcase.to_sym).new(w_id)
        return esc.actual_commands
      end
      
    end
    
  end
  
end