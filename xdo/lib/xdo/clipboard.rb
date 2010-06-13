#Encoding: UTF-8
require_relative("../xdo")

module XDo
  
  #A module for interaction with the X clipboard. Please note, that the X clipboard 
  #consists of three parts: The PRIMARY clipboard, the CLIPBOARD clipboard, and 
  #the SECONDARY clipboard. The clipboard you access normally via [CTRL]+[C] 
  #or by right-clicking and selecting "copy", is usually the CLIPBOARD clipboard (but that 
  #depends on the application you use). The three main methods of this module (#read, #write 
  #and #clear) take a hash with the symbols of the clipboards to interact with. If you don't want to 
  #pass in the symbols, use the predefined read_xy, write_xy and clear_xy methods. They cannot 
  #access more than one clipboard at a time. 
  #The symbols for the clipboards are: 
  #[PRIMARY] :primary
  #[SECONDARY] :secondary
  #[CLIPBOARD] :clipboard
  module Clipboard
    
    class << self
      
      ##
      # :singleton-method: read_primary
      
      ##
      # :singleton-method: read_clipboard
      
      ##
      # :singleton-method: read_secondary
      
      ##
      # :singleton-method: write_primary
      
      ##
      # :singleton-method: write_clipboard
      
      ##
      # :singleton-method: write_secondary
      
      ##
      # :singleton-method: clear_primary
      
      ##
      # :singleton-method: clear_clipboard
      
      ##
      # :singleton-method: clear_secondary
      
      [:primary, :clipboard, :secondary].each do |sym|
        
        define_method(:"read_#{sym}") do
          read({sym => true})[sym]
        end
        
        define_method(:"write_#{sym}") do |text|
          write(text, {sym => true})
          text
        end
        
        define_method(:"clear_#{sym}") do
          clear({sym => true})
          nil
        end
        
      end
      
      #Reads text from the X clipboard. The +from+ argument specifies 
      #from what clipboard you want to read (in 70% of all cases you 
      #want to read from :clipboard). Return value is a hash with the 
      #clipboards you specified as the keys. The contents of the clipboards 
      #are the values. You can also use one of the read_xy methods directly. 
      def read(from = {:clipboard => true})
        hsh = {}
        hsh[:primary] = `#{XSEL}` if from[:primary]
        hsh[:clipboard] = `#{XSEL} -b` if from[:clipboard]
        hsh[:secondary] = `#{XSEL} -s` if from[:secondary]
        hsh
      end
      
      #Writes data to the X clipboard. The +to+ argument soecifies 
      #the clipboard you want to write to. If you want to be able to paste 
      #your text via [CTRL]+[v], use :clipboard. You can also use the 
      #write_xy methods if you don't want to pass in the hash. 
      def write(text, to = {:primary => true, :clipboard => true})
        IO.popen("xsel -i", "w"){|io| io.write(text)} if to[:primary]
        IO.popen("xsel -b -i", "w"){|io| io.write(text)} if to[:clipboard]
        IO.popen("xsel -s -i", "w"){|io| io.write(text)} if to[:secondary]
        text
      end
      
      #Append data to text already written to the X clipboard. As in #write, 
      #you can specify the clipboard you want to append text to. 
      def append(text, to = {:primary => true, :clipboard => true})
        IO.popen("xsel -a -i", "w"){|io| io.write(text)} if to[:primary]
        IO.popen("xsel -b -a -i", "w"){|io| io.write(text)} if to[:clipboard]
        IO.popen("xsel -s -a -i", "w"){|io| io.write(text)} if to[:secondary]
      end
      
      #Clears the specified clipboards. 
      def clear(clips = {:primary => true, :clipboard => true})
        `#{XSEL} -c` if clips[:primary]
        `#{XSEL} -b -c` if clips[:clipboard]
        `#{XSEL} -s -c` if clips[:secondary]
        nil
      end
      
    end
  end
end