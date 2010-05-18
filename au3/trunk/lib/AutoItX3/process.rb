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
    #
    #Closes the given process. 
    #===Parameters
    #[+pid+] The PID or name of the process to close. 
    #===Return value
    #nil. 
    #===Example
    #  AutoItX3.close_process(1234)
    #===Remarks
    #This method doesn't ask the process to terminate nicely, it just kills it. 
    #If you're familiar with Unix process signals, this method is nearer to 
    #sending SIGKILL than sending SIGTERM. 
    def close_process(pid)
      @functions[__method__] ||= AU3_Function.new("ProcessClose", 'S', 'L')
      @functions[__method__].call(pid.to_s.wide)
      nil
    end
    alias kill_process close_process
    
    #Checks wheather or not the given name or PID exists. 
    #===Parameters
    #[+pid+] The PID or name of the process to check. 
    #===Return value
    #false if the process doesn't exist, otherwise the PID of the process. 
    #===Example
    #  p AutoItX3.process_exists?(1234) #=> false
    #  p AutoItX3.process_exists("ruby.exe") #=> 4084
    def process_exists?(pid)
      @functions[__method__] ||= AU3_Function.new("ProcessExists", 'S', 'L')
      pid = @functions[__method__].call(pid.to_s.wide)
      pid > 0 && pid
    end
    
    #Sets a process's priority. 
    #===Parameters
    #[+pid+] The PID or name of the process whose priority you want to change. 
    #[+priority+] One of the *_PRIORITY constants. 
    #===Return value
    #The argument passed as +priority+. 
    #===Raises
    #[Au3Error] You passed an invalid priority value or some other error occured. 
    #===Example
    #  AutoItX3.set_process_priority(4084, AutoItX3::HIGH_PRIORITY)
    #  AutoItX3.set_process_priority("ruby.exe", AutoItX3::SUBNORMAL_PRIORITY)
    #===Remarks
    #You shouldn't set a process's priority to REALTIME_PRIORITY, since that 
    #is the priority system processes run with which are likely more important than your process. 
    #The same goes the other way round: Don't decrease a system process's priority. 
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
    
    #Waits for the given process name to exist. 
    #===Parameters
    #[+procname+] The name of the process to wait for. 
    #[+timeout+] (+0+)  The time to wait, in seconds. The default is to wait infinitely. 
    #===Return value
    #true if the process was found, false if +timeout+ was reached. 
    #===Example
    #  AutoItX3.wait_for_process("nonexistant.exe", 2) #| false
    #  AutoItX3.wait_for_process("ruby.exe") #| true
    #===Remarks
    #This is the only process-related method that doesn't take a PID, 
    #because to wait for a special PID doesn't make sense, since PIDs 
    #are generated randomly. 
    def wait_for_process(procname, timeout = 0)
      @functions[__method__] ||= AU3_Function.new("ProcessWait", 'SL', 'L')
      @functions[__method__].call(procname.to_s.wide, timeout) == 1
    end
    
    #Waits for the given process name or PID to disappear. 
    #===Parameters
    #[+pid+] The PID or process name to wait for. 
    #[+timeout+] The time to wait, in seconds. 0 means to wait infinitely, which is the default. 
    #===Return value
    #true if the process disappeared, false if +timeout+ was reached. 
    #===Example
    #  AutoItX3.wait_for_process_close(4084) #| true
    #  AutoItX3.wait_for_process_close("ruby.exe", 1) #| false
    #  #Attention on this one: 
    #  AutoItX3.wait_for_process_close("nonexistant.exe") #| true
    def wait_for_process_close(pid, timeout = 0)
      @functions[__method__] ||= AU3_Function.new("ProcessWaitClose", 'SL', 'L')
      @functions[__method__].call(pid.to_s.wide, timeout) == 1
    end
    
    #Runs a program. 
    #===Parameters
    #[+name+] The command to run. 
    #[+workingdir+] (<tt>""</tt>) The working directory to start the process in. Default is the current one. 
    #[+flag+] (+1+) Additional properties you want to set on the window. Possible value include SW_HIDE, SW_MINIMIZE and SW_MAXIMIZE, which are defined as constants of the Window class. Default is to set nothing. 
    #===Return value
    #The PID of the newly created process. 
    #===Raises
    #[Au3Error] Couldn't awake the specified program. 
    #===Example
    #  p AutoItX3.run("notepad.exe") #=> 502
    #===Remarks
    #The program flow continues; if you want to wait for the process to 
    #finish, use #run_and_wait. 
    def run(name, workingdir = "", flag = 1)
      @functions[__method__] ||= AU3_Function.new("Run", 'SSL', 'L')
      pid = @functions[__method__].call(name.wide, workingdir.wide, flag)
      raise(Au3Error, "An error occured while starting process '#{name}'!") if last_error == 1
      pid
    end
    
    #Runs a program and waits until the process has finished. 
    #===Parameters
    #[+name+] The command to run. 
    #[+workingdir+] (<tt>""</tt>) The working directory to start the process in. Default is the current one. 
    #[+flag+] (+1+) Additional properties you want to set on the window. Possible value include SW_HIDE, SW_MINIMIZE and SW_MAXIMIZE, which are defined as constants of the Window class. Default is to set nothing. 
    #===Return value
    #The exitcode of the process. 
    #===Raises
    #[Au3Error] Couldn't awake the specified program. 
    #===Example
    #  AutoItX3.run_and_wait("ipconfig") #| 0
    #  AutoItX3.run_and_wait("nonexistant.exe")
    #===Remarks
    #If you don't want to wait until the program has finished, use #run. 
    #
    #This method doesn't do anything different from Ruby's own Kernel#system method beside 
    #the flag you can pass to GUI applications. 
    def run_and_wait(name, workingdir = "", flag = 1)
      @functions[__method__] ||= AU3_Function.new("RunWait", 'SSL', 'L')
      exitcode = @functions[__method__].call(name.wide, workingdir.wide, flag)
      raise(Au3Error, "An error occured while starting process '#{name}'!") if last_error == 1
      exitcode
    end
    
    #Changes the the owner of following  #run and #run_and_wait methods to the given 
    #user. 
    #===Parameters
    #[+username+] The name of the user you want to run commands as. 
    #[+domain+] The user's domain. 
    #[+password+] The user's password. 
    #[+options+] (+1+) One of the following: 0: don't load the user profile, 1 (default): load the user profile, 2: Only for networking. 
    #===Return value
    #nil. 
    #===Raises
    #[NotImplementedError] You're using Windows ME or earlier which don't support this method. 
    #===Example
    #  AutoItX3.run_as_set("Rubyist", "WORKGROUP", "MyFamousUncrackablePassword")
    #  AutoItX3.run("hack_them_all.exe")
    def run_as_set(username, domain, password, options = 1)
      @functions[__method__] ||= AU3_Function.new("RunAsSet", 'SSSI', 'L')
      if @functions[__method__].call(username.wide, domain.wide, password.wide, options) == 0
        raise(NotImplementedError, "Your system does not support the #run_as_set method.")
      end
      nil
    end
    
    #Shuts down or reboots your computer, or logs you off. 
    #===Parameters
    #[+code+] One of the following constants: SHUTDOWN, REBOOT, LOGOFF. You may combine (by using addition with +) each of them with FORCE_CLOSE which forces all hanging applications to close. Additionally, you may combine SHUTDOWN with POWEROFF which ensures that your computer gets cut off from the power supply.     
    #===Return value
    #Unknown. 
    #===Example
    #  AutoItX3.shutdown(AutoItX3::LOGOFF | AutoItX3::FORCE_CLOSE)
    #  AutoItX3.shutdown(AutoItX3::REBOOT)
    #  AutoItX3.shutdown(AutoItX3::SHUTDOWN + AutoItX3::FORCE_CLOSE + AutoItX3::POWEROFF)
    #  #If your computer is still running after executing this sequence of commands, you may should check your hardware. 
    def shutdown(code)
      @functions[__method__] ||= AU3_Function.new("Shutdown", 'L', 'L')
      @functions[__method__].call(code) == 1
    end
    
  end
  
end
