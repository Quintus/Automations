#Encoding: UTF-8
#This file is part of au3. 
#Copyright © 2009 Marvin Gülker
#
#au3 is published under the same terms as Ruby. 
#See http://www.ruby-lang.org/en/LICENSE.txt

module AutoItX3
  
  class << self
    
    #Maps a network drive.  
    #===Parameters
    #Every | is ment to be a backslash. 
    #[+device+] The device letter to map the drive to, in the form <tt>"X:"</tt>. If this is an asterisk *, the next available letter will be used. 
    #[+remote_share+] The address of the network drive, in the form <tt>"||Server|Drive"</tt> or <tt>"||Server|Share"</tt>. 
    #[+flags+] (0) A combination (via +) of 1 (PersistantMapping) and 8 (Show authentification dialog if neccessary). 
    #[+username+] ("") The username, of the form <tt>"username"</tt> or <tt>"Domain|username"</tt>. 
    #[+password+] (""): The login password. 
    #===Return value
    #The assigned drive letter. 
    #===Raises
    #[Au3Error] Failed to connect the network drive. 
    def add_drive_map(device, remote_share, flags = 0, username = "", password = "")
      @functions[__method__] ||= AU3_Function.new("DriveMapAdd", 'SSLSSPI')
      buffer = " " * BUFFER_SIZE
      buffer.wide!
      @functions[__method__].call(device, remote_share, flags, username, password, buffer, buffer.size - 1)
      
      case last_error
        when 1 then raise(Au3Error, "Unknown error occured while mapping network drive!")
        when 2 then raise(Au3Error, "Access denied!")
        when 3 then raise(Au3Error, "Device '#{device}' is already assigned!")
        when 4 then raise(Au3Error, "Invalid device name '#{device}'!")
        when 5 then raise(Au3Error, "Invalid remote share '#{remote_share}'!")
        when 6 then raise(Au3Error, "The password is incorrect!")
        else return buffer.normal.strip
      end
    end
    
    #Disconnects a network drive. 
    #===Parameters
    #[+device+] The device to disconnect. Can be either of form <tt>"X:"</tt> or <tt>"||Server|share</tt> (| is a backslash). 
    #===Return value
    #nil. 
    #===Raises
    #[Au3Error] Couldn't disconnect the network drive. 
    def delete_drive_map(device)
      @functions[__method__] ||= AU3_Function.new("DriveMapDel", 'S', 'L')
      result = @functions[__method__].call(device)
      if result == 0
        raise(Au3Error, "Failed to remove remote device '#{device}'!")
      end
      nil
    end
    
    #Gets the server of a network drive. 
    #===Parameters
    #[+device+] The device to check. 
    #===Return value
    #A string of form <tt>"||Server|drive"</tt>, where every | is meant to be a backslash. 
    #===Raises
    #[Au3Error] Couldn't retrieve the requested information. 
    def get_drive_map(device)
      @functions[__method__] ||= AU3_Function.new("DriveMapGet", 'SPI')
      buffer = " " * BUFFER_SIZE
      buffer.wide!
      ret = @functions[__method__].call(device, buffer, buffer.size - 1)
      
      if last_error == 1
        raise(Au3Error, "Failed to retrieve information about device '#{device}'")
      end
      buffer.normal.strip
    end
    
    #Deletes a key-value pair in a standard <tt>.ini</tt> file. 
    #===Parameters
    #[+filename+] The filename of the file. 
    #[+section+] The section the key resides in. 
    #[+key+] The key to delete. 
    #===Return value
    #true on success, otherwise false. 
    #===Example
    #  AutoItX3.delete_ini_entry("myini.ini", "mysection", "mykey")
    def delete_ini_entry(filename, section, key)
      @functions[__method__] ||= AU3_Function.new("IniDelete", 'SSS', 'L')
      if @functions[__method__].call(filename.wide, section.wide, key.wide) == 0
        false
      else
        true
      end
    end
    
    #Reads a value from a standard <tt>.ini</tt> file. 
    #===Parameters
    #[+filename+] The filename of the file. 
    #[+section+] The section the key resides in. 
    #[+key+] The key to read. 
    #[+default+] ("")A string to return on failure. 
    #===Return value
    #The value of the +default+ parameter. 
    #===Example
    #  puts AutoItX3.read_ini_entry("myini.ini", "mysection", "mykey") #=> myvalue
    #  #Nonexistant key: 
    #  puts AutoItX3.read_ini_entry("myini.ini", "mysection", "mynonexsistingkey") #=> 
    #  #With default value
    #  puts AutoItX3.read_ini_entry("myini,ini", "mysection", "mynonexsistingkey", "NOTHING") #=> NOTHING
    #===Remarks
    #The returned string has a maximum length of <tt>AutoItX3::BUFFER_SIZE - 1 </tt> characters. 
    def read_ini_entry(filename, section, key, default = "")
      @functions[__method__] ||= AU3_Function.new("IniRead", 'SSSSPI')
      buffer = " " * BUFFER_SIZE
      buffer.wide!
      @functions[__method__].call(filename.wide, section.wide, key.wide, default.to_s.wide, buffer, buffer.size - 1)
      buffer.normal.strip
    end
    
    #Writes the specified key-value pair in a <tt>.ini</tt> file. 
    #===Parameters
    #[+filename+] The file's filename. 
    #[+section+] The section you want to write in. 
    #[+key+] The key whose value you want to write. 
    #[+value+] The value to write. 
    #===Return value
    #The +value+ argument. 
    #===Raises
    #[Au3Error] +filename+ is read-only. 
    #===Example
    #  AutoItX3.write_ini_entry("minini.ini", "mysection", "mykey", "myvalue")
    #===Remarks
    #Both the +section+ and the +key+ will be created if they aren't there already. Likewise is the file if nonexistant. 
    #
    #If the specified key-value pair already exists, it will be overwritten. 
    def write_ini_entry(filename, section, key_value, value)
      @functions[__method__] ||= AU3_Function.new("IniWrite", 'SSSS', 'L')
      
      if @functions[__method__].call(filename.wide, section.wide, key_value.wide, value.wide) == 0
        raise(Au3Error, "Cannot open file for write access!")
      else
        value
      end
    end
    
  end #au3single
  
end #AutoItX3
