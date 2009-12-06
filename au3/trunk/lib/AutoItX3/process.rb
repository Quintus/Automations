#Encoding: UTF-8
#This file is part of au3. 
#Copyright © 2009 Marvin Gülker
#
#au3 is published under the same terms as Ruby. 
#See http://www.ruby-lang.org/en/LICENSE.txt

module AutoItX3
  
  #Lowest process priorety
  IDLE_PRIORITY = 0
  #Subnormal process priority
  SUBNORMAL_PRIORITY = 1
  #Normal process priority
  NORMAL_PRIORITY = 2
  #Process priority above normal
  SUPNORMAL_PRIORITY = 3
  #High process priority
  HIGH_PRIORITY = 4
  #Highest process priority. Use this with caution, it's is the priority system processes run with. 
  REALTIME_PRIORITY = 5
  
  #Logs the currect user out
  LOGOFF = 0
  #Shuts the computer down
  SHUTDOWN = 1
  #Reboot the computer
  REBOOT = 2
  #Force hanging applications to close
  FORCE_CLOSE = 4
  #Turn the power off after shutting down (if the computer supports this)
  POWER_DOWN = 8
  
  class << self
    
    #call-seq: 
    #  close_process(pid) ==> nil
    #  kill_process(pid) ==> nil
    #Closes the given process. 
    def close_process(pid)
      @functions[__method__] ||= AU3_Function.new("ProcessClose", 'S', 'L')
      @functions[__method__].call(pid.to_s.wide)
      nil
    end
    alias kill_process close_process
    
    #Checks wheather or not the given name or PID exists. If successful, 
    #this method returns the PID of the process. 
    def process_exists?(pid)
      @functions[__method__] ||= AU3_Function.new("ProcessExists", 'S', 'L')
      pid = @functions[__method__].call(pid.to_s.wide)
      if pid == 0
        false
      else
        pid
      end
      
    end
    
    #Sets a process's priority. Use one of the *_PRIORITY constants. 
    def set_process_priority(pid, priority)
      @functions[__method__] ||= AU3_Function.new("ProcessSetPriority", 'SL', 'L')
      @functions[__method__].call(pid.to_s.wide, priority)
      
      case last_error
        when 1 then raise(Au3Error, "Unknown error occured when trying to set process priority of '#{pid}'!")
        when 2 then raise(Au3Error, "Unsupported priority '#{priority}'!")
        else
          return priority
      end
    end
    
    #Waits for the given process name to exist. This is the only process-related 
    #method that doesn't take a PID, because to wait for a special PID doesn't make 
    #sense, since PIDs are generated randomly. 
    #
    #Return false if +timeout+ was reached. 
    def wait_for_process(procname, timeout = 0)
      @functions[__method__] ||= AU3_Function.new("ProcessWait", 'SL', 'L')
      if @functions[__method__].call(procname.to_s.wide, timeout) == 0
        false
      else
        true
      end
    end
    
    #Waits for the given process name or PID to disappear. 
    #
    #Returns false if +timeout+ was reached. 
    def wait_for_process_close(pid, timeout = 0)
      @functions[__method__] ||= AU3_Function.new("ProcessWaitClose", 'SL', 'L')
      if @functions[__method__].call(pid.to_s.wide, timeout) == 0
        false
      else
        true
      end
    end
    
    #Runs a program. The program flow continues, if you want to wait for the process to 
    #finish, use #run_and_wait. 
    #Returns the PID of the created process or nil if there was a failure starting the process. 
    #The +flag+ parameter can be one of the SW_HIDE, SW_MINIMZE or SW_MAXIMIZE 
    #constants in the Window class. 
    def run(name, workingdir = "", flag = 1)
      @functions[__method__] ||= AU3_Function.new("Run", 'SSL', 'L')
      pid = @functions[__method__].call(name.wide, workingdir.wide, flag)
      raise(Au3Error, "An error occured while starting process '#{name}'!") if last_error == 1
      pid
    end
    
    #Runs a program. This method waits until the process has finished and returns 
    #the exitcode of the process (or false if there was an error initializing it). If 
    #you don't want this behaviour, use #run. 
    #The +flag+ parameter can be one of the SW_HIDE, SW_MINIMZE or SW_MAXIMIZE 
    #constants in the Window class. 
    def run_and_wait(name, workingdir = "", flag = 1)
      @functions[__method__] ||= AU3_Function.new("RunWait", 'SSL', 'L')
      exitcode = @functions[__method__].call(name.wide, workingdir.wide, flag)
      raise(Au3Error, "An error occured while starting process '#{name}'!") if last_error == 1
      exitcode
    end
    
    #Changes the the owner of following  #run and #run_and_wait methods to the given 
    #user. Raises a NotImplementedError if your system is Win2000 or older. 
    def run_as_set(username, domain, password, options = 1)
      @functions[__method__] ||= AU3_Function.new("RunAsSet", 'SSSI', 'L')
      if @functions[__method__].call(username.wide, domain.wide, password.wide, options) == 0
        raise(NotImplementedError, "Your system does not support the #run_as_set method.")
      end
      nil
    end
    
    #Executes one of the the following commands: 
    #- SHUTDOWN
    #- REBOOT
    #- LOGOFF
    #You can combine the above actions with the below constants, except 
    #LOGOFF and POWER_DOWN. Use the + operator to combine them. 
    #- FORCE_CLOSE
    #- POWER_DOWN
    def shutdown(code)
      @functions[__method__] ||= AU3_Function.new("Shutdown", 'L', 'L')
      if @functions[__method__].call(code) == 0
        false
      else
        true
      end
    end
    
  end
  
end