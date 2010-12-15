#Encoding: UTF-8
#This file is part of Xdo.
#Copyright © 2009, 2010 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat.

module Automations
    
  #A namespace encabsulating methods to simulate keyboard input. You can
  #send input to special windows, just pass in the window's ID or a XWindow
  #object via the +w_id+ parameter.
  module Keyboard
    
    #Aliases for key names in escape sequences.
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
      "CTRL" => "Control_L",
      "ALT" => "Alt_L",
      "ALT_GR" => "ISO_Level3_Shift",
      "WIN" => "Super_L",
      "SUPER" => "Super_L"
      }.freeze
      
      #The names of some keyboard symbols. The latest release of
      #xdotool is capable of sending keysymbols directly, i.e.
      #  xdotool key Adiaeresis
      #results in Ä being sent.
      #This hash defines how those special characters can be
      #sent. Feel free to add characters that are missing! You
      #can use the +xev+ program to obtain their keycodes.
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
      "|" => "bar",
      "?" => "question"
    }
    
    class << self
      
      #Types a character sequence, but without any special chars.
      #===Parameters
      #[+str+] The string to type.
      #[+w_id+] (0) The ID of the window you want the input send to (or an XWindow object). 0 means the active window.
      #===Return value
      #nil.
      #===Example
      #  XDo::Keyboard.type("test")
      #  XDo::Keyboard.type("täst") #=> I don't what key produces '�', skipping.
      #===Remarks
      #This function is a bit faster then #simulate.
      def type(str, w_id = 0)
        out = Open3.popen3("#{XDOTOOL} type #{w_id.nonzero? ? "--window #{w_id.to_i} " : ""}'#{str}'") do |stdin, stdout, stderr|
        stdin.close_write
        str = stderr.read
        warn(str) unless str.empty?
      end
      nil
    end
    
    #Types a character sequence. You can use the escape sequence {...} to send special
    #keystrokes.
    #===Parameters
    #[+str+] The string to simulate.
    #[+raw+] (false) If true, escape sequences via {...} are disabled. See _Remarks_.
    #[+w_id+] (0) The ID of the window you want the input send to (or an XWindow object). 0 means the active window.
    #===Return value
    #The string that was simulated.
    #===Raises
    #[ParseError] Your string was invalid.
    #===Example
    #  XDo::Keyboard.simulate("test")
    #  XDo::Keyboard.simulate("täst")
    #  XDo::Keyboard.simulate("tex{BS}st")
    #===Remarks
    #This method recognizes many special chars like ? and ä, even if you disable
    #the escape syntax {..} via setting the +raw+ parameter to true (that's the only way to send the { and } chars).
    #
    #+str+ may contain escape sequences in braces { and }. The letters between those two indicate
    #what special character to send - this way you can simulate non-letter keypresses like [ESC]!
    #You may use the following escape sequences:
    #  Escape seq. | Keystroke         | Comment
    #  ============+===================+=================
    #  ALT         | [Alt_L]           |
    #  ------------+-------------------------------------
    #  ALT_GR      | [ISO_Level3_Shift]| Not on USA
    #              |                   | keyboard
    #  ------------+-------------------------------------
    #  BS          | [BackSpace]       |
    #  ------------+-------------------------------------
    #  BACKSPACE   | [BackSpace]       |
    #  ------------+-------------------------------------
    #  CTRL        | [Control_L]       |
    #  ------------+-------------------------------------
    #  DEL         | [Delete]          |
    #  ------------+-------------------------------------
    #  END         | [End]             |
    #  ------------+-------------------------------------
    #  ESC         | [Escape]          |
    #  ------------+-------------------------------------
    #  INS         | [Insert]          |
    #  ------------+-------------------------------------
    #  HOME        | [Home]            |
    #  ------------+-------------------------------------
    #  MENU        | [Menu]            | Usually right-
    #              |                   | click menu
    #  ------------+-------------------------------------
    #  NUM0..NUM9  | [KP_0]..[KP_9]    | Numpad keys
    #  ------------+-------------------------------------
    #  NUM_DIV     | [KP_Divide]       | Numpad key
    #  ------------+-------------------------------------
    #  NUM_MUL     | [KP_Multiply]     | Numpad key
    #  ------------+-------------------------------------
    #  NUM_SUB     | [KP_Subtract]     | Numpad key
    #  ------------+-------------------------------------
    #  NUM_ADD     | [KP_Add]          | Numpad key
    #  ------------+-------------------------------------
    #  NUM_ENTER   | [KP_Enter]        | Numpad key
    #  ------------+-------------------------------------
    #  NUM_DEL     | [KP_Delete]       | Numpad key
    #  ------------+-------------------------------------
    #  NUM_COMMA   | [KP_Separator]    | Numpad key
    #  ------------+-------------------------------------
    #  NUM_INS     | [KP_Insert]       | Numpad key
    #  ------------+-------------------------------------
    #  PAUSE       | [Pause]           |
    #  ------------+-------------------------------------
    #  PGUP        | [Prior]           | Page up
    #  ------------+-------------------------------------
    #  PGDN        | [Next]            | Page down
    #  ------------+-------------------------------------
    #  PRINT       | [Print]           |
    #  ------------+-------------------------------------
    #  SUPER       | [Super_L]         | Windows key
    #  ------------+-------------------------------------
    #  TAB         | [Tab]             |
    #  ------------+-------------------------------------
    #  WIN         | [Super_L]         | Windows key
    def simulate(str, raw = false, w_id = 0)
        raise(XDo::XError, "Invalid number of open and close braces!") unless str.scan(/{/).size == str.scan(/}/).size
        
        tokens = tokenize(str)
        
        tokens.each do |sym, s|
          case sym
          when :plain then type(s, w_id.to_i)
          when :esc then
            if raw
                type("{#{s}}", w_id.to_i) #The braces should be preserved when using +raw+.
              else
                if ALIASES.has_key?(s)
                  key(ALIASES[s])
                else
                  char(s.split("_").map(&:capitalize).join("_"), w_id.to_i)
                end
              end
            when :special then
              if SPECIAL_CHARS.has_key?(s)
                char(SPECIAL_CHARS[s], w_id.to_i)
              else
                raise(XDo::ParseError, "No key symbol known for '#{s}'!")
              end
            else #Write a bug report if you get here. That really shouldn't happen.
              raise(XDo::ParseError, "Invalid token named #{sym.inspect}! This is an internal error - please write a bug report at http://github.com/Quintus/Automations/issues or email me at sutniuq@@gmx@net.")
            end
          end
          str
        end
        
        #Simulate a single char directly via the +key+ command of +xdotool+.
        #===Parameters
        #[+c+] A single char like "a" or a combination like "shift+a".
        #[+w_id+] (0) The ID of the window you want the input send to (or an XWindow object). 0 means the active window.
        #===Return value
        #The +c+ you passed in.
        #===Raises
        #[XError] Invalid keyname.
        #===Example
        #  XDo::Keyboard.char("a") #=> a
        #  XDo::Keyboard.char("A") #=> A
        #  XDo::Keyboard.char("ctrl+c")
        def char(c, w_id = 0)
        Open3.popen3("#{XDOTOOL} key #{w_id.nonzero? ? "--window #{w_id.to_i} " : ""}#{c}") do |stdin, stdout, stderr|
        stdin.close_write
        raise(XDo::XError, "Invalid character '#{c}'!") if stderr.read =~ /No such key name/
      end
      c
    end
    alias key char
    
    #Holds a key down.
    #===Parameters
    #[+key+] The key to hold down.
    #[+w_id+] (0) The ID of the window you want the input send to (or an XWindow object). 0 means the active window.
    #===Return value
    #+key+.
    #===Raises
    #[XError] Invalid keyname.
    #===Example
    #  XDo::Keyboard.key_down("a")
    #  sleep 2
    #  XDo::Keyboard.key_up("a")
    #===Remarks
    #You should release the key sometime via Keyboard.key_up.
    def key_down(key, w_id = 0)
        Open3.popen3("#{XDOTOOL} keydown #{w_id.nonzero? ? "--window #{w_id.to_i} " : "" }#{check_for_special_key(key)}") do |stdin, stdout, stderr|
        stdin.close_write
        raise(XDo::XError, "Invalid character '#{key}'!") if stderr.read =~ /No such key name/
      end
      key
    end
    
    #Releases a key hold down by #key_down.
    #===Parameters
    #[+key+] The key to release.
    #[+w_id+] (0) The ID of the window you want the input send to (or an XWindow object). 0 means the active window.
    #===Return value
    #+key+.
    #===Raises
    #[XError] Invalid keyname.
    #===Example
    #  XDo::Keyboard.key_down("a")
    #  sleep 2
    #  XDo::Keyboard.key_up("a")
    #===Remarks
    #This has no effect on already released keys.
    def key_up(key, w_id = 0)
        Open3.popen3("#{XDOTOOL} keyup #{w_id.nonzero? ? "--window #{w_id.to_i} " : "" }#{check_for_special_key(key)}") do |stdin, stdout, stderr|
        stdin.close_write
        raise(XDo::XError, "Invalid character '#{key}'!") if stderr.read =~ /No such key name/
      end
      key
    end
    
    #Deletes a char.
    #===Parameters
    #[right] (false) If this is true, +del_char+ uses the DEL key for deletion, otherwise the BackSpace key.
    #===Return value
    #nil.
    #===Example
    #  XDo::Keyboard.delete
    #  XDo::Keyboard.delete(true)
    def delete(right = false)
        Keyboard.simulate(right ? "\b" : "{DEL}")
        nil
      end
      
      #Allows you to things like this:
      #  XDo::Keyboard.ctrl_c
      #The string will be capitalized and every _ will be replaced by a + and then passed into #char.
      #You can't use this way to send whitespace or _ characters.
      def method_missing(sym, *args, &block)
        super if args.size > 1 or block
        char(sym.to_s.capitalize.gsub("_", "+"), args[0].nil? ? 0 : args[0])
      end
      
      private
      
      #Tokenizes a string into an array of form
      #  [[:plain, "nonspecial"], [:special, "a"], [:esc, "INS"], ...]
      def tokenize(str)
        tokens = []
        #We need a binary version of our string as StringScanner isn't able to work
        #with encodings.
        ss = StringScanner.new(str.dup.force_encoding("BINARY")) #String#force_encoding always returns self
        until ss.eos?
          pos = ss.pos
          if ss.scan_until(/{/)
            #Get the string between the last and the recent match. We have to subtract 2 here,
            #since a StringScanner position is always ahead of the string character by 1 (since 0 in
            #a SmallScanner means "before the first character") and the matched brace shouldn't be
            #included.
            tokens << [:plain, ss.string[Range.new(pos, ss.pos - 2)]] unless ss.pos == 1 #This means, the escape sequence is at the beginning of the string - no :plain text before.
            pos = ss.pos
            ss.scan_until(/}/)
            tokens << [:esc, ss.string[Range.new(pos, ss.pos - 2)]] #See above for comment on -2
          else #We're behind the last escape sequence now - there must be some characters left, otherwise this wouldn't be triggered.
            tokens << [:plain, ss.rest]
            ss.terminate
          end
        end
        #Now hunt for special character like ä which can't be send using xdotool's type command.
        regexp = Regexp.union(*SPECIAL_CHARS.keys.map{|st| st}) #Regexp.union escapes automatically, no need for Regexp.escape
        tokens.map! do |ary|
          #But first, we have to remedy from that insane forced encoding for StringScanner.
          #Force every string's encoding back to the original encoding.
          ary[1].force_encoding(str.encoding)
          next([ary]) unless ary[0] == :plain #Extra array since we flatten(1) it afterwards
          tokens2 = []
          ss = StringScanner.new(ary[1])
          until ss.eos?
            pos = ss.pos
            if ss.scan_until(regexp)
              #Same as for the first StringScanner encoding problem goes here, but since I now have to use a UTF-8 regexp
              #I have to put the string into the StringScanner as UTF-8, but because the StringScanner returns positions for
              #a BINARY-encoded string I have to get the string, grep the position from the BINARY version and then reforce
              #it to the correct encoding.
              tokens2 << [:plain, ss.string.dup.force_encoding("BINARY")[Range.new(pos, ss.pos - 2)].force_encoding(str.encoding)] unless ss.pos == 1
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
      
      #Checks wheather +key+ is a special character (i.e. contained
      #in the SPECIAL_CHARS hash) and returns the key symbol for it if so,
      #otherwise returns +key+.
      def check_for_special_key(key)
        SPECIAL_CHARS.has_key?(key) ? SPECIAL_CHARS[key] : key
      end
      
    end
    
  end
  
end