#!/usr/bin/env ruby
#Encoding: UTF-8
#--
#This file is part of XDo. Copyright © 2009 by Marvin Gülker. 
#XDo is published under Ruby's license. See http://www.ruby-lang.org/en/LICENSE.txt
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 
#++

=begin
This is the full XDo demo. We will create a 
command-line program that will be able to open 
and close the default CD drive, open gedit and 
type some text in tabular form and click the 
"show desktop" button in the lower-left corner of 
the Ubuntu desktop. Even if you don't use Ubuntu, 
you may get the logic and find this demo useful. 

Every OS and even every computer are different in their 
user interface. If you'd like to add sample files for a 
specific OS, feel free to contact me at sutniuq ät gmx Dot net. 
=end

#First, require all Xdo files. 
require "xdo/clipboard"
require "xdo/drive"
require "xdo/keyboard"
require "xdo/mouse"
require "xdo/xwindow"

class XXX
  
  def keyboard
    #Make sure gedit is not running, since it would open 
    #a new tab and not a new window if invoked again. 
    raise(RuntimeError, "gedit is already running; please close it before using.") unless XDo::XWindow.search("gedit").empty?
    #If we would use system in the main program to open 
    #gedit, it would hang until gedit is closed. That's why 
    #we run it in a separate process. 
    fork{system("gedit")}
    #Now we wait until gedit has made up its GUI. 
    #wait_for_window returns the ID of the found window, so 
    #we catch it and...
    id = XDo::XWindow.wait_for_window("gedit")
    #...use it to create a new reference to gedit's window. 
    #Note that this is a pseudo reference, not a real one. 
    #XDo allows you to create references even to unexisting 
    #windows, so the X window manager will not recognize 
    #the pseudo reference. You can check if the window 
    #you're looking for exists by calling #exists? on the 
    #XWindow object. 
    xwin = XDo::XWindow.new(id)
    #Now we move it 20 pixels right and 10 down. 
    xwin.move(xwin.position[0] + 20, xwin.position[1] + 10)
    #After having fun with it, let's do something useful. 
    #XDo::Keyboard.simulate fakes keystrokes and recognizes 
    #special escape sequences in braces { and }. For some 
    #special characters like tab you can use an ASCII escape 
    #like \t. The most special keys like [ESC] don't have 
    #those a shortcut, so you will have to write {ESC} in 
    #order to send them. 
    XDo::Keyboard.simulate("This will be some test text.")
    XDo::Keyboard.ctrl_a
    XDo::Keyboard.delete #This will send a BackSpace keypress. If you want a DEL, pass in true as a parameter. 
    #I promised at the beginning, we were goint to create data in tabular form, 
    #so here it is: 
    XDo::Keyboard.type("Percentage of smokers in different jobs in Germany".upcase) #type is usually faster than simulate if the text doesn't contain special characters or escape sequences
    2.times{XDo::Keyboard.return} #Return is the Enter key
    #Set up the data
    headings = ["Job", "Percentage"]
    data = [
      ["Judge", 28], 
      ["Architect", 29], 
      ["Doctor", 30], 
      ["Nurse", 45], 
      ["Teacher", 53]
    ]
    #Create the table headings
    str =""
    headings[0..-2].each{|h| str << h << "{TAB}{TAB}"}
    str << headings[-1] << "\n"#No tab after the last heading
    #Type the heading
    XDo::Keyboard.simulate(str)
    #Make a line between the heading and the data
    XDo::Keyboard.type("=" * 30)
    XDo::Keyboard.return
    #Write the table data
    data.each do |job, percentage|
      #Insert tabs. If a word is longer than 8 (the normal tab size), don't append a second tab. 
      XDo::Keyboard.simulate("#{job}#{job.length > 8 ? "\t" : "\t\t"}#{percentage}\n") #\t will trigger the Tab key, \n the Return key. 
    end
    #Oh yes, and save it of course. XDo::Keyboard tries to 
    #send every method name as a key combination if the 
    #method is not defined already. The method name 
    #will be capitalized and every underscore _ replaced 
    #by a + (that's internally important to combine keys). 
    File.delete("#{ENV["HOME"]}/testXDo.txt") if File.file? "#{ENV["HOME"]}/testXDo.txt" #This is the file we'll save to
    XDo::Keyboard.ctrl_s
    #Wait for the save window to exist. I can't use wait_for_window here, since 
    #it's named different in every language. Me as a German user have a title 
    #of "Speichern unter...", an english OS may show "Save as...". 
    sleep 1
    #You really shouldn't try to simulate the ~ sign. xdotool seems to have a bug, so 
    #~ can't be simulated with one command. My library tries to simulate it with one 
    #command and it sometimes works, but you mustn't rely on it. Therefore I use 
    #the HOME environment variable here to get the home directory, rather than ~. 
    XDo::Keyboard.simulate("#{ENV["HOME"]}/testXDo.txt")
    sleep 1 #gedit terminates if send [ALT]+[A] immediatly after the path
    XDo::Keyboard.alt_s
    #Now, let's duplicate our table. We could send all the stuff again, 
    #but I want to introduce you in the use of the X clipboard. 
    #First, we have to mark our text in order to be copied to the clipboard: 
    xwin.activate #After saving the window isn't active anymore
    sleep 1 #Wait for the gedit window to be active again
    XDo::Keyboard.ctrl_a
    #Then copy it to the clipboard (you see, it's quite useful to know keyboard shortcuts)
    XDo::Keyboard.ctrl_c
    #gedit copies, like the most programs, it's data to the CLIPBOARD clipboard. 
    #There are two other clipboard, PRIMARY and SECONDARY, but we won't 
    #diskuss them here. If you are sure you've copied data to the clipboard and 
    ##read_clipboard doesn't find anything, check out #read_primary and #read_secondary. 
    #Also note, that XDo can only handle plain text data. 
    cliptext = XDo::Clipboard.read_clipboard
    #Move to the end of the text
    XDo::Keyboard.simulate("{DOWN}" * 9)
    XDo::Keyboard.simulate("{END}")
    #Since #simulate interprets \t correctly as a tab, we can simply put 
    #the clipboard's text in that method: 
    XDo::Keyboard.simulate("\n#{cliptext}") #Begin a new line before inserting the duplicate
    sleep 1
    XDo::Keyboard.ctrl_s
    #Give some time to see the result
    sleep 5
    #Than close gedit. There are three methods to close a window, 
    ##close, #close! and #kill!. #close is like sending an [ALT]+[F4] keypress which may result in 
    #a dialog box asking you for confimation. #close! is a bit stronger. First it calls #close and waits 
    #a few seconds (you can specify how long exactly) then shuts down the window process. What 
    #leads us to the third method: #kill!. Be sure to call #kill! only on windows you know - 
    #it kills the process of a window by sending SIGTERM first and then SIGKILL. I've not tried 
    #what happens if you send this to the desktop window, but if you like to...
    xwin.close #We use the normal #close here since we saved our data and gedit shouldn't complain. 
  end
  
  def mouse
    #Assuming that the first entry of your right-click menu is "Create folder", 
    #you can create new folders on your desktop. 
    XDo::XWindow.toggle_minimize_all
    sleep 2
    
    #Mouse.click is the method for executing mouse clicks. If you call it 
    #without any arguments, it will execute a left click on the current cursor position. 
    XDo::Mouse.click(400, 400, XDo::Mouse::RIGHT)
    sleep 1 #Give the menu time to appear
    XDo::Mouse.click
    sleep 1 #Wait for the folder to be created
    #Give it a name
    XDo::Keyboard.simulate("A test folder\n") # Return to confirm
    sleep 1 #Wait to accept the name
    #Move the folder icon a bit upwards
    XDo::Mouse.drag(nil, nil, 400, 200)
    sleep 2
    XDo::XWindow.toggle_minimize_all #Restore all windows
  end
  
end

USAGE =<<USAGE
USAGE: 
./full_demo.rb [methodname]

Executes the full_demo XDo demo file. You can optionally provide a method 
name, if you don't, both methods will be run. 
USAGE

if ARGV.include?("-h") or ARGV.include?("--help")
  puts USAGE
end

xxx = XXX.new
if ARGV.empty?
  xxx.keyboard
  sleep 3
  xxx.mouse
elsif ARGV[0] == "mouse"
  xxx.mouse
elsif ARGV[0] == "keyboard"
  xxx.keyboard
else
  puts USAGE
end
