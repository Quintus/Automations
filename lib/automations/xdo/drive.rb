#Encoding: UTF-8
require_relative("../xdo")

module XDo
  
  #Some methods to interact with disk drives. 
  #The value of the +drive+ parameter of many methods can be 
  #either a mount point like <tt>/media/my_cdrom</tt>, a device file like <tt>scd0</tt> 
  #or the default name "cdrom" for the default drive. 
  #
  #If you don't pass in a drive name, the return value of #default will 
  #be used. 
  module Drive
    
    class << self
      
      #Opens a drive. 
      #===Parameters
      #[drive] (<tt>default()</tt>) The drive to open. 
      #===Return value
      #  True. 
      #===Raises
      #[XError] You're using a laptop whose drive has to be closed manually. 
      #[XError] +eject+ failed. 
      #===Example
      #  XDo::Drive.eject("scd0")
      #  XDo::Drive.eject("/media/my_cdrom")
      #===Remarks
      #This method may silently fail if the device is blocked by e.g. a 
      #CD burning program. Have a look at #release if you want to force 
      #it to open. 
      def eject(drive = default)
        err = ""
        Open3.popen3("#{XDo::EJECT} #{drive}"){|stdin, stdout, stderr| err << stderr.read}
        raise(XDo::XError, err) unless err.empty?
        true
      end
      
      #Closes a drive. 
      #===Parameters
      #[drive] (<tt>default()</tt>) The drive to close. 
      #===Return value
      #Undefined. 
      #===Raises
      #[XError] +eject+ failed. 
      #===Example
      #  XDo::Drive.eject("scd0")
      #  XDo::Drive.close
      #  
      #  XDo::Drive.eject("/dev/my_cdrom")
      #  XDo::Drive.close("scd0") #A mount point doesn't make sense here
      def close(drive = default)        
        err = ""
        Open3.popen3("eject -t #{drive}"){|stdin, stdout, stderr| err << stderr.read}
        raise(XDo::XError, err) unless err.empty?
      end
      
      #Returns the mount point of the default drive. 
      #You can use it as a value for a +drive+ parameter. 
      #===Return value
      #The default drive's name. Usually <tt>"cdrom"</tt>. 
      #===Raises
      #[XError] +eject+ failed. 
      #===Example
      #  p XDo::Drive.default #=> "cdrom"
      #  XDo::Drive.eject(XDo::Drive.default)
      def default
        err = ""
        out = ""
        Open3.popen3("#{XDo::EJECT} -d"){|stdin, stdout, stderr| out << stdout.read; err << stderr.read}
        raise(XDo::XError, err) unless err.empty?
        out.match(/`(.*)'/)[1]
      end
      
      #Locks a drive, so that it can't be opened by 
      #using the eject button or the +eject+ command. 
      #===Parameters
      #[drive] (<tt>default()</tt>) The drive to lock. 
      #===Return value
      #true. 
      #===Raises
      #[XError] +eject+ failed. 
      #===Example
      #  XDo::Drive.lock("scd0")
      #  XDo::Drive.eject # fails
      #  XDo::Drive.release
      #  XDo::Drive.eject("scd0") #succeeds
      #===Remarks
      #Note that the lock doesn't get released if your process exits. 
      #You should probably register a at_exit handler to avoid confusion 
      #when your program exits with an exception. 
      def lock(drive = default)
        err = ""
        Open3.popen3("#{XDo::EJECT} -i on #{drive}"){|stdin, stdout, stderr| err << stderr.read}
        raise(XDo::XError, err) unless err.empty?
        true
      end
      
      #Unlocks a drive, so that it can be opened 
      #by neither the eject button nor the +eject+ command.  
      #===Parameters
      #[drive] The drive to remove the lock from. 
      #===Return value
      #true. 
      #===Raises
      #[XError] +eject+ failed. 
      #===Example
      #  XDo::Drive.lock("scd0")
      #  XDo::Drive.eject # fails
      #  XDo::Drive.release
      #  XDo::Drive.eject("scd0") #succeeds
      #===Remarks
      #Use with caution. If a burning program locked the drive and 
      #you force it to open, the resulting CD-ROM is garbage. 
      def release(drive = default)
        drive = default unless drive
        err = ""
        Open3.popen3("#{XDo::EJECT} -i off #{drive}"){|stdin, stdout, stderr| err << stderr.read}
        raise(XDo::XError,err) unless err.empty?
        true
      end
      
    end
  end
end