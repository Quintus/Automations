#Encoding: UTF-8
require "open3"
require_relative("../xdo")

module XDo
  
  #Some methods to interact with CD (and DVD, of course) drives. 
  #The value of the +drive+ parameter of many methods can be 
  #either a mount point or a device file like scd0. 
  #
  #If you don't pass in a drive name, the returnvalue of #default will 
  #be used. 
  module Drive
    
    class << self
      include Open3
      #Opens a drive. 
      def eject(drive = nil)
        err = ""
        drive = default unless drive
        popen3("#{XDo::EJECT} #{drive}"){|stdin, stdout, stderr| err << stderr.read}
        raise(XDo::XError, err) unless err.empty?
        true
      end
      
      #Closes a drive. 
      def close(drive = nil)
        drive = default unless drive
        err = ""
        popen3("eject -t #{drive}"){|stdin, stdout, stderr| err << stderr.read}
        raise(XDo::XError, err) unless err.empty?
      end
      
      #Returns the mount point of the default drive. 
      #You can use it as a value for a +drive+ parameter. 
      def default
        err = ""
        out = ""
        popen3("#{XDo::EJECT} -d"){|stdin, stdout, stderr| out << stdout.read; err << stderr.read}
        raise(XDo::XError, err) unless err.empty?
        out.match(/`(.*)'/)[1]
      end
      
      #Locks a drive, so that it can't be opened by 
      #using the eject button. 
      def lock(drive = nil)
        drive = default unless drive
        err = ""
        popen3("#{XDo::EJECT} -i on #{drive}"){|stdin, stdout, stderr| err << stderr.read}
        raise(XDo::XError, err) unless err.empty?
        true
      end
      
      #Unlocks a drive, so that it can be opened 
      #by the eject button. 
      def release(drive = nil)
        drive = default unless drive
        err = ""
        popen3("#{XDo::EJECT} -i off #{drive}")
        raise(XDo::XError,err) unless err.empty?
        true
      end
      
    end
  end
end