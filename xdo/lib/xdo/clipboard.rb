#Encoding: UTF-8
#This file is part of Xdo. 
#Copyright © 2009, 2010 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 

require_relative("../xdo")

module XDo
  
  #A module for interaction with the X clipboard. Please note, that the X clipboard 
  #consists of three parts: The PRIMARY clipboard, the CLIPBOARD clipboard, and 
  #the SECONDARY clipboard. The clipboard you access normally via [CTRL]+[C] 
  #or by right-clicking and selecting "copy", is usually the CLIPBOARD clipboard (but that 
  #depends on the application you use). The three main methods of this module (#read, #write 
  #and #clear) take a list symbols of the clipboards to interact with. If you don't want to 
  #pass in the symbols, use the predefined read_xy, write_xy and clear_xy methods. They cannot 
  #access more than one clipboard at a time. 
  #The symbols for the clipboards are: 
  #[PRIMARY] :primary
  #[SECONDARY] :secondary
  #[CLIPBOARD] :clipboard
  #You cannot store complex objects like images via this interface, only strings. However, 
  #you could translate an image into a string (packed pixels maybe?) and put that on the 
  #clipboard -- for your own application this may be fine, but it won't magically allow 
  #a user to paste that image into a graphics program. 
  #
  #The +xsel+ program used by this module is quite outdated. As far as I can see, it's 
  #last update happened in 2002 and since I do not believe that software exists that 
  #won't break over a period of 8 years without a single modification while updating systems I'm about to 
  #switch to a newer one. +xclip+ is likely, but that one got it's last update in early 
  #2009... 
  module Clipboard
    
    class << self
      
      ##
      # :singleton-method: read_primary
      #Returns the contents of the PRIMARY clipboard. 
      #See #read for an explanation. 
      
      ##
      # :singleton-method: read_clipboard
      #Returns the contents of the CLIPBOARD clipboard. 
      #See #read for an explanation. 
      
      ##
      # :singleton-method: read_secondary
      #Returns the contents of the SECONDARY clipboard. 
      #See #read for an explanation. 
      
      ##
      # :singleton-method: write_primary
      #Writes to the PRIMARY clipboard. 
      #See #write for an explanation. 
      
      ##
      # :singleton-method: write_clipboard
      #Writes to the CLIPBOARD clipboard. 
      #See #write for an explanation. 
      
      ##
      # :singleton-method: write_secondary
      #Writes to the SECONDARY clipboard. 
      #See #write for an explanation. 
      
      ##
      # :singleton-method: clear_primary
      #Clears the PRIMARY clipboard. 
      #See #clear for an explanation. 
      
      ##
      # :singleton-method: clear_clipboard
      #Clears the CLIPBOARD clipboard. 
      #See #clear for an explanation. 
      
      ##
      # :singleton-method: clear_secondary     
      #Clears the SECONDARY clipboard. 
      #See #clear for an explanation. 
      
      #Reads text from a X clipboard. 
      #===Parameters
      #[<tt>*from</tt>] (<tt>:clipboard</tt>, <tt>:primary</tt>, <tt>:secondary</tt>) Specifies from which clipboards you want to read (in 70% of all cases you want to read from <tt>:clipboard</tt>). 
      #===Return value
      #A hash of form
      #  {:clip_sym => "clipboard_content"}
      #If you didn't pass any arguments to #read, the hash will contain keys for 
      #all clipboard, i.e. for <tt>:clipboard</tt>, <tt>:primary</tt> and <tt>:secondary</tt>. 
      #If you did, only those symbols will be included you passed. See 
      #the _Example_ section for an example of this. 
      #===Example
      #  XDo::Clipboard.read #| {:clipboard => "...", :primary => "...", :secondary => "..."}
      #  XDo::Clipboard.read(:primary) #| {:primary => "..."}
      #  XDo::Clipboard.read(:clipboard, :secondary) #| {clipboard => "...", :secondary => "..."}
      #===Remarks
      #You could also use one of the read_* methods for convenience.       
      def read(*from)
        if from.first.kind_of? Hash
          warn("#{caller.first}: Deprecation warning: Use symbols as a rest argument now!")
          from = from.first.keys
        end
        from.concat([:clipboard, :primary, :secondary]) if from.empty?
        
        hsh = {}
        hsh[:primary] = `#{XSEL}` if from.include? :primary
        hsh[:clipboard] = `#{XSEL} -b` if from.include? :clipboard
        hsh[:secondary] = `#{XSEL} -s` if from.include? :secondary
        hsh
      end
        
      
      #Writes text to a X clipboard. 
      #===Parameters
      #[<tt>*to</tt>] (<tt>:clipboard</tt>) Specifies to what clipboards you want to wrote to. 
      #===Return value
      #The text written. 
      #===Example
      #  XDo::Clipboard.write("I love Ruby") #You can now paste this via [CTRL] + [V]
      #  XDo::Clipboard.write("I love Ruby", :primary) #You can now paste this via a middle-mouse-button click
      #  XDo::Clipboard.write("I love Ruby", :clipboard, :primary) #Both of the above
      #===Remarks
      #You could also use one of the write_* methods for convenience. 
      def write(text, *to)
        if to.first.kind_of? Hash
          warn("#{caller.first}: Deprecation warning: Use symbols as a rest argument now!")
          to = to.first.keys
        end
        to << :clipboard if to.empty?
        
        IO.popen("xsel -i", "w"){|io| io.write(text)} if to.include? :primary
        IO.popen("xsel -b -i", "w"){|io| io.write(text)} if to.include? :clipboard
        IO.popen("xsel -s -i", "w"){|io| io.write(text)} if to.include? :secondary
        text
      end
      
      #Appends text to a X clipboard. 
      #===Parameters
      #[+text+] The text to append. 
      #[<tt>*to</tt>] (<tt>:clipboard</tt>) The clipboards to which you want to append. 
      #===Return value
      #Undefined. 
      #===Example
      #  XDo::Clipboard.write("I love ")
      #  XDo::Clipboard.append("Ruby")
      #  puts XDo::Clipboard.read(:clipboard)[:clipboard] #=> I love Ruby
      #  
      #  XDo::Clipboard.write("I love", :primary)
      #  XDo::Clipboard.append("Ruby", :primary, :clipboard)
      #  #If you now paste via [CTRL] + [V], you'll get 'Ruby'. If you 
      #  #paste via the middle mouse button, you'll get 'I love Ruby' 
      #  #(Assuming you didn't execute the first block of code, of course). 
      def append(text, *to)
        if to.first.kind_of? Hash
          warn("#{caller.first}: Deprecation warning: Use symbols as a rest argument now!")
          to = to.first.keys
        end
        to << :clipboard if to.empty?
        
        IO.popen("xsel -a -i", "w"){|io| io.write(text)} if to.include? :primary
        IO.popen("xsel -b -a -i", "w"){|io| io.write(text)} if to.include? :clipboard
        IO.popen("xsel -s -a -i", "w"){|io| io.write(text)} if to.include? :secondary
      end
      
      #Clears the specified clipboards. 
      #===Parameters
      #[<tt>*clips</tt>] (<tt>:primary</tt>, <tt>:clipboard</tt>, <tt>:secondary</tt>) The clipboards you want to clear. 
      #===Return value
      #nil. 
      #===Example
      #  XDo::Clipboard.write("I love Ruby")
      #  XDo::Clipboard.clear
      #  #Nothing can be pasted anymore
      #  
      #  XDo::Clipboard.write("I love Ruby", :clipboard, :primary)
      #  XDo::Clipboard.clear(:primary)
      #  #You can still paste via [CTRL] + [V], but not with the middle mouse button
      def clear(*clips)
        if clips.first.kind_of? Hash
          warn("#{caller.first}: Deprecation warning: Use symbols as a rest argument now!")
          clips = clips.first.keys
        end
        clips.concat([:primary, :clipboard, :secondary]) if clips.empty?
        
        `#{XSEL} -c` if clips.include? :primary
        `#{XSEL} -b -c` if clips.include? :clipboard
        `#{XSEL} -s -c` if clips.inclde? :secondary
        nil
      end
      
      [:primary, :clipboard, :secondary].each do |sym|
        
        define_method(:"read_#{sym}") do
          read(sym)[sym]
        end
        
        define_method(:"write_#{sym}") do |text|
          write(text, sym)
        end
        
        define_method(:"clear_#{sym}") do
          clear(sym)
        end
        
      end
      
    end
  end
end