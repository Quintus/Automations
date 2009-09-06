/*
*This file is part of au3. 
*Copyright © 2009 Marvin Gülker
*
*au3 is published under the same terms as Ruby. 
*See http://www.ruby-lang.org/en/LICENSE.txt
*
*=au3.c
*Main file of the AutoItX-Ruby API. Defines the Init_au3 function and 
*documents the methods of this library because RDoc cannot find the 
*subfiles in the parts subdirectory. 
*/

//--
//================================================================
//BEGIN DOCUMENTATION
//================================================================
//++

/*Document-class: AutoItX3
*
*This module encapsulates all methods to interact with 
*AutoItX3. Every method is documented, so you should't have 
*problems with using them. However, a few notes: 
*==Mouse Functions
*Many mouse functions take an argument called +button+. This can be one 
*of the following strings: 
*  String              | Normal result   | Swapped buttons
*  ====================+=================+================
*  "" (empty string)   | Left            | Left
*  --------------------+-----------------+----------------
*  Left                | Left            | Left
*  --------------------+-----------------+----------------
*  Right               | Right           | Right
*  --------------------+-----------------+----------------
*  Middle              | Middle          | Middle
*  --------------------+-----------------+----------------
*  Primary             | Left            | Right
*  --------------------+-----------------+----------------
*  Secondary           | Right           | Left
*  --------------------+-----------------+----------------
*  Main                | Left            | Right
*  --------------------+-----------------+----------------
*  Menu                | Right           | Left
*==Process Functions
*The +pid+ parameter of many process functions 
*needn't to be a process identification number, you can 
*also pass in the name of the process. Please note, that 
*in that case the first process with +pid+ in its name is 
*assumed to be the correct one. 
*
*/

/*
*Document-class: AutoItX3::Au3Error
*
*This class is used for errors in this library. 
*/

/*
*Document-class: AutoItX3::Window
*
*A Window object holds a (pseudo) reference to a 
*window that may be shown on the screen or not. 
*If you want to get a real handle to the window, 
*call #handle on your Window object (but you won't 
*need that unless you want to use it for Win32 API calls). 
*/

/*
*Document-class: AutoItX3::Control
*
*This is the superclass for all controls. If you don't find 
*a subclass of Control that matches your specific control, 
*you can use the Control class itself (and if you call 
*Window#focused_control, you *will* have to use it, 
*since that method retuns a Control and not a subclass). 
*/

/*
*Document-class: AutoItX3::ListBox
*
*List boxes are controls in which you can select one 
*or multiple items by clicking on it. ListBox is also 
*the superclass of ComboBox. 
*/

/*
*Document-class: AutoItX3::ComboBox
*
*A combo box is a control on which you click 
*and then select a single item from the droped 
*list box. 
*/

/*
*Document-class: AutoItX3::Button
*
*A button is a control on which you can click and than something happens. 
*Even if that's quite correct, that isn't all: check and radio boxes 
*are handled by Windows as buttons, so they fall into the scope of this class. 
*/

/*
*Document-class: AutoItX3::Edit
*
*An edit control is a single- or multiline input control in which you can 
*type text. For example, notepad consists mainly of a big edit control. 
*/

/*
*Document-class: AutoItX3::TabBook
*A tab book or tab bar is a control that shows up most often 
*at the top of a window and lets you choice between different 
*contents within the same window. 
*/

//--
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//BEGIN DOCUMENTATION misc.c
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//++

/*
*Document-method: AutoItX3.last_error
*
*call-seq: 
*  AutoItX3.last_error ==> aFixnum
*
*Returns the error code of the last called AutoItX3 function, which is 0 if 
*everything worked fine. The returned value will be between -5 and 5. 
*/

/*
*Document-method: AutoItX3.set_option
*
*call-seq: 
*  AutoItX3.set_option( option [, value ] ) ==> anInteger
*  AutoItX3.opt( option [, value ] ) ==> anInteger
*
*Sets an option that changes the behaviour of AutoIt. 
*The following options are possible: 
*
*  Option              | Description
*  ====================+============================================================
*  CaretCoordMode      | Sets the way coords are used in the caret functions, 
*                      | either absolute coords or coords relative to the current 
*                      | active window:
*                      | 0 = relative coords to the active window
*                      | 1 = absolute screen coordinates (default)
*                      | 2 = relative coords to the client area of the active window
*  --------------------+------------------------------------------------------------
*  ColorMode           | Sets the way colors are defined, either RGB or BGR. RGB is 
*                      | the default but in previous versions of AutoIt (pre 3.0.102) 
*                      | BGR was the default:
*                      | 0 = Colors are defined as RGB (0xRRGGBB) (default)
*                      | 1 = Colors are defined as BGR (0xBBGGRR) (the mode used in 
*                      |     older versions of AutoIt)
*  --------------------+------------------------------------------------------------
*  MouseClickDelay     | Alters the length of the brief pause in between mouse 
*                      | clicks. 
*                      | Time in milliseconds to pause (default=10). 
*  --------------------+------------------------------------------------------------
*  MouseClickDownDelay | Alters the length a click is held down before release. 
*                      | Time in milliseconds to pause (default=10). 
*  --------------------+------------------------------------------------------------
*  MouseClickDragDelay | Alters the length of the brief pause at the start and 
*                      | end of a mouse drag operation. 
*                      | Time in milliseconds to pause (default=250). 
*  --------------------+------------------------------------------------------------
*  MouseCoordMode      | Sets the way coords are used in the mouse functions, 
*                      | either absolute coords or coords relative to the current 
*                      | active window: 
*                      | 0 = relative coords to the active window
*                      | 1 = absolute screen coordinates (default)
*                      | 2 = relative coords to the client area of the active window
*  --------------------+------------------------------------------------------------
*  PixelCoordMode      | Sets the way coords are used in the pixel functions, 
*                      | either absolute coords or coords relative to the current 
*                      | active window:
*                      | 0 = relative coords to the active window
*                      | 1 = absolute screen coordinates (default)
*                      | 2 = relative coords to the client area of the active window
*  --------------------+------------------------------------------------------------
*  SendAttachMode      | Specifies if AutoIt attaches input threads when using then 
*                      | Send() function. When not attaching (default mode=0) 
*                      | detecting the state of capslock/scrolllock and numlock 
*                      | can be unreliable under NT4. However, when you specify 
*                      | attach mode=1 the Send("{... down/up}") syntax will not 
*                      | work and there may be problems with sending keys to "hung" 
*                      | windows. ControlSend() ALWAYS attaches and is not affected 
*                      | by this mode. 
*                      | 0 = don't attach (default)
*                      | 1 = attach
*  --------------------+------------------------------------------------------------
*  SendCapslockMode    | Specifies if AutoIt should store the state of capslock 
*                      | before a Send function and restore it afterwards. 
*                      | 0 = don't store/restore
*                      | 1 = store and restore (default)
*  --------------------+------------------------------------------------------------
*  SendKeyDelay        | Alters the the length of the brief pause in between 
*                      | sent keystrokes. 
*                      | Time in milliseconds to pause (default=5). Sometimes a 
*                      | value of 0 does not work; use 1 instead.
*  --------------------+------------------------------------------------------------
*  SendKeyDownDelay    | Alters the length of time a key is held down before 
*                      | released during a keystroke. For applications that 
*                      | take a while to register keypresses (and many games) 
*                      | you may need to raise this value from the default. 
*                      | Time in milliseconds to pause (default=1).
*  --------------------+------------------------------------------------------------
*  WinDetectHiddenText | Specifies if hidden window text can be "seen" by the 
*                      | window matching functions. 
*                      | 0 = Do not detect hidden text (default)
*                      | 1 = Detect hidden text
*  --------------------+------------------------------------------------------------
*  WinSearchChildren   | Allows the window search routines to search child windows 
*                      | as well as top-level windows. 
*                      | 0 = Only search top-level windows (default)
*                      | 1 = Search top-level and child windows
*  --------------------+------------------------------------------------------------
*  WinTextMatchMode    | Alters the method that is used to match window text 
*                      | during search operations. 
*                      | 1 = Complete / Slow mode (default)
*                      | 2 = Quick mode
*                      | In quick mode AutoIt can usually only "see" dialog text, 
*                      | button text and the captions of some controls. In the 
*                      | default mode much more text can be seen (for instance the 
*                      | contents of the Notepad window). 
*                      | If you are having performance problems when performing 
*                      | many window searches then changing to the "quick" mode may 
*                      | help. 
*  --------------------+------------------------------------------------------------
*  WinTitleMatchMode   | Alters the method that is used to match window titles 
*                      | during search operations. 
*                      | 1 = Match the title from the start (default)
*                      | 2 = Match any substring in the title
*                      | 3 = Exact title match
*                      | 4 = Advanced mode, see the AutoItX3 help. 
*  --------------------+------------------------------------------------------------
*  WinWaitDelay        | Alters how long a script should briefly pause after a 
*                      | successful window-related operation. 
*                      | Time in milliseconds to pause (default=250). 
*
*The table above was copied from the the AutoItX3 help file. 
*====Returnvalue
*The previous value of the option. 
*/

/*
*Document-method: AutoItX3.block_input=
*
*call-seq: 
*  AutoItX3.block_input = block ==> true or false
*
*Blocks user input or enables it (but the user can gain back control by 
*pressing [CTRL] + [ALT] + [DEL]). In older versions of Windows, 
*AutoIt may also be blocked. 
*/

/*
*Document-method: AutoItX3.input_blocked?
*
*call-seq: 
*  AutoItX3.input_blocked? ==> true or false
*
*Determines wheather or not input is blocked by #block_input= . 
*/

/*
*Document-method: AutoItX3.open_cd_tray
*
*call-seq: 
*  AutoItX3.open_cd_tray( drive ) ==> true or false
*
*Opens the cd drive named in +drive+. +drive+ should be of form 
*<tt>"X:"</tt>. The cd tray must be local at this computer, remote drives 
*cannot be accessed. 
*====Returnvalue
*true, if the drive was opened successfully, Otherwise false (the cd tray may be locked), 
*/

/*
*Document-method: AutoItX3.close_cd_tray
*
*call-seq: 
*  AutoItX3.close_cd_tray( drive ) ==> true or false
*
*Closes a cd tray. +drive+ should be of form <tt>"X:"</tt>. The cd tray must 
*be local at this computer, remote drives cannot be accessed. 
*The method may return true if +drive+ is a laptop drive which can only be 
*closed manually. 
*====Returnvalue
*true if the drive was closed successfully, false ohterwise (the drive may be locked). 
*/

/*
*Document-method: AutoItX3.is_admin?
*
*call-seq: 
*  AutoItX3.is_admin? ==> true or false
*
*Determines wheather the current user has administrator privileges. 
*/

//--
//This method seems to have been removed. 
/*
*Document-method: AutoItX3.download_file
*
*call-seq: 
*  AutoItX3.download_file( url , target ) ==> true or false
*
*Downloads a website or file. This method tries to load the file from the 
*IE cache first, so Internet Explorer 3 or higher must be installed. 
*/
//++

/*
*Document-method: AutoItX3.cliptext=
*
*call-seq: 
*  AutoItX3.cliptext = text ==> nil
*  AutoItX3.write_clipboard( text ) ==> nil
*
*Writes +text+ to the Windows clipboard. 
*You can't write NUL characters to the clipboard, the text will 
*be terminated. 
*/

/*
*Document-method: AutoItX3.cliptext
*
*call-seq: 
*  AutoItX3.cliptext ==> aString
*  AutoItX3.read_clipboard ==> aString
*
*Read text from the clipboard. If the clipboard is empty or contains 
*a non-text entry, an empty string "" will be returned. The maximum length 
*that can be returned is 9999 characters. 
*/

/*
*Document-method: AutoItX3.tool_tip
*
*call-seq: 
*  AutoItX3.tool_tip( str [, x = INTDEFAULT, y = INTDEFAULT] ) ==> nil
*  AutoItX3.tooltip( str [, x = INTDEFAULT, y = INTDEFAULT] ) ==> nil
*
*Displays a tooltip at the given position. If +x+ and +y+ are ommited, 
*the tooltip will be displayed at the current cursor position. Coordinates 
*out of range are automatically corrected. 
*The tooltip will be deleted when the program ends, or after a system-dependent 
*timeout. 
*/

/*
*Document-method: AutoItX3.msleep
*
*call-seq: 
*  AutoItX3.msleep( msecs ) ==> nil
*
*Wait for the specified amount of milliseconds. In AutoIt, this function is named 
*"Sleep", but to avoid compatibility issues with Ruby's own sleep I decided to 
*name the function "msleep" (the "m" indicates "milli"). If you wish to name it 
*"sleep", simply define an alias. 
*/

//--
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//END DOCUMENTATION misc.c
//BEGIN DOCUMENTATION filedir.c
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//++

/*
*Document-method: AutoItX3.add_drive_map
*
*call-seq: 
*  AutoItX3.add_drive_map( device , remote_share [, flags [, username [, password ] ] ] ) ==> aString
*
*====Arguments
*- device: The device letter to map the drive to, in the form <tt>"X:"</tt>. If this is an asterisk *, the next available letter will be used. 
*- remote_share: The address of the network drive, in the form <tt>"\\Server\Drive"</tt> or <tt>"\\Server\Share"</tt>. 
*- flags (0): A combination (via +) of 1 (PersistantMapping) and 8 (Show authentification dialog if neccessary). 
*- username (""): The username, of the form <tt>"username"</tt> or <tt>"Domain\username"</tt>. 
*- password (""): The login password. 
*====Description
*Maps a network drive and raises an Au3Error if the action is not successful. 
*/

/*
*Document-method: AutoItX3.delete_drive_map
*
*call-seq: 
*  AutoItX3.delete_drive_map( device ) ==> true or false
*
*Disconnects a network drive. +device+ can be either of form <tt>"X:"</tt> or 
*<tt>"\\Server\share"</tt>. 
*/

/*
*Document-method: AutoItX3.get_drive_map
*
*call-seq: 
*  AutoItX3.get_drive_map( device ) ==> aString
*
*Gets the server of the network drive named by +device+ or raises an Au3Error if it 
*can't access the device for some reason. The returned string will be of form 
*<tt>"\\Server\\drive"</tt>. 
*/

/*
*Document-method: AutoItX3.delete_ini_entry
*
*call-seq: 
*  AutoItX3.delete_ini_entry( filename , section , key ) ==> true or false
*
*Deletes a key-value pair in a standard <tt>.ini</tt> file. 
*/

/*
*Document-method: AutoItX3.read_ini_entry
*
*call-seq: 
*  AutoItX3.read_ini_entry( filename , section , key , default ) ==> aString
*
*Reads a value from a standard <tt>.ini</tt> file or returns the string given by +default+ 
*if it can't find the key. The returned string will have a maximum length of 9999 characters. 
*/

/*
*Document-method: AutoItX3.write_ini_entry
*
*call-seq: 
*  AutoItX3.write_ini_entry( filename , section , key , value ) ==> value
*
*Writes the specified key-value pair in a <tt>.ini</tt> file. Existing key-value pairs are overwritten. 
*A non-existing file will be created. Raises an Au3Error if +filename+ is read-only. 
*/

//--
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//END DOCUMENTATION filedir.c
//BEGIN DOCUMENTATION graphic.c
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//++

/*
*Document-method: AutoItX3.pixel_checksum
*
*call-seq: 
*  AutoItX3.pixel_checksum( x1 , y1 , x2 , y2 [, step = 1] ) ==> anInteger
*
*Computes a checksum of the pixels in the specified region. If the checksum 
*changes, that only indidcates that *something* has changed, not *what*. 
*Note that this method may be very time-consuming, so think about increasing the 
*+step+ parameter (but bear in mind that that will generate more inaccurate checksums). 
*/

/*
*Document-method: AutoItX3.get_pixel_color
*
*call-seq: 
*  AutoItX3.get_pixel_color( x , y ) ==> aInteger
*  AutoItX3.pixel_color( x , y ) ==> aInteger
*
*Retrieves the *decimal* color value of a pixel. If you want the hexadecimal, use: 
*  "#" + AutoItX3.get_pixel_color(x, y).to_s(16).upcase
*which will return the hexadecimal color string in form <tt>"#RRGGBB"</tt> 
*(unless you changed +ColorMode+ via the #set_option method). 
*/

/*
*Document-method: AutoItX3.search_for_pixel
*
*call-seq: 
*  AutoItX3.search_for_pixel(x1 , y1 , x2 , y2 , color [, shade_variation = 0 [, step = 1 ] ] ) ==> anArray
*  AutoItX3.pixel_search(x1 , y1 , x2 , y2 , color [, shade_variation = 0 [, step = 1 ] ] ) ==> anArray
*  AutoItX3.search_pixel(x1 , y1 , x2 , y2 , color [, shade_variation = 0 [, step = 1 ] ] ) ==> anArray
*
*Searches the given area for the given color. +shade_variation+ indicates how big the difference to 
*the searched color can be at max. If +step+ is other than 1, every <tt>step</tt>-th pixel is searched 
*in the area. 
*Return value is a two-element array of form <tt>[x, y]</tt>. 
*/

//--
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//END DOCUMENTATION graphic.c
//BEGIN DOCUMENTATION keyboard.c
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//++

/*
*Document-method: AutoItX3.send_keys
*
*call-seq: 
*  AutoItX3.send( keys [, flag = "" ] ) ==> nil
*
*Simulates the keystrokes given keystrokes. If you don't 
*set +flag+ to 1, you may use some of the follwing escape 
*sequences in braces { and } (copied from the AutoItX3 help): 
*  Escape sequence     | Resulting keypress
*  ====================+============================================================
*  !                   | !
*  --------------------+------------------------------------------------------------
*  #                   | #
*  --------------------+------------------------------------------------------------
*  +                   | +
*  --------------------+------------------------------------------------------------
*  ^                   | ^
*  --------------------+------------------------------------------------------------
*  {                   | {
*  --------------------+------------------------------------------------------------
*  }                   | }
*  --------------------+------------------------------------------------------------
*  SPACE               | SPACE
*  --------------------+------------------------------------------------------------
*  ENTER               | Return on the main keyboard
*  --------------------+------------------------------------------------------------
*  ALT                 | Alt
*  --------------------+------------------------------------------------------------
*  BACKSPACE or BS     | Backspace
*  --------------------+------------------------------------------------------------
*  DELETE or DEL       | Del
*  --------------------+------------------------------------------------------------
*  UP                  | Up arrow
*  --------------------+------------------------------------------------------------
*  DOWN                | Down arrow
*  --------------------+------------------------------------------------------------
*  LEFT                | Left arrow
*  --------------------+------------------------------------------------------------
*  RIGHT               | Right arrow
*  --------------------+------------------------------------------------------------
*  HOME                | Home
*  --------------------+------------------------------------------------------------
*  END                 | End
*  --------------------+------------------------------------------------------------
*  ESCAPE or ESC       | ESC
*  --------------------+------------------------------------------------------------
*  INSERT or INS       | Ins
*  --------------------+------------------------------------------------------------
*  PGUP                | Page Up
*  --------------------+------------------------------------------------------------
*  PGDN                | Page Down
*  --------------------+------------------------------------------------------------
*  F1 - F12            | Function keys 1 to 12
*  --------------------+------------------------------------------------------------
*  TAB                 | Tab
*  --------------------+------------------------------------------------------------
*  PRINTSCREEN         | Printscreen
*  --------------------+------------------------------------------------------------
*  LWIN                | Left Windows key
*  --------------------+------------------------------------------------------------
*  RWIN                | Right Windows key
*  --------------------+------------------------------------------------------------
*  NUMLOCK on          | NumLock on
*  --------------------+------------------------------------------------------------
*  CAPSLOCK off        | CapsLock off
*  --------------------+------------------------------------------------------------
*  SCROLLLOCK toggle   | ScrollLock toggle
*  --------------------+------------------------------------------------------------
*  BREAK               | For CTRL-Break processing
*  --------------------+------------------------------------------------------------
*  PAUSE               | Pause
*  --------------------+------------------------------------------------------------
*  NUMPAD0 - NUMPAD9   | Numpad number keys. 
*  --------------------+------------------------------------------------------------
*  NUMPADMUTLT         | Numpad Multipy
*  --------------------+------------------------------------------------------------
*  NUMPADADD           | Numpad Add
*  --------------------+------------------------------------------------------------
*  NUMPADSUBT          | Numpad Subtract
*  --------------------+------------------------------------------------------------
*  NUMPADDIV           | Numpad Division
*  --------------------+------------------------------------------------------------
*  NUMPADDOT           | Numpad dot
*  --------------------+------------------------------------------------------------
*  NUMPADENTER         | Numpad return key
*  --------------------+------------------------------------------------------------
*  APPSKEY             | Windows App key
*  --------------------+------------------------------------------------------------
*  LALT                | Left Alt key
*  --------------------+------------------------------------------------------------
*  RALT                | Right Alt key
*  --------------------+------------------------------------------------------------
*  LCTRL               | Left control key
*  --------------------+------------------------------------------------------------
*  LSHIFT              | Left Shift key
*  --------------------+------------------------------------------------------------
*  RSHIFT              | Right Shift key
*  --------------------+------------------------------------------------------------
*  SLEEP               | Computer Sleep key
*  --------------------+------------------------------------------------------------
*  ALTDOWN             | Hold Alt down until ALTUP is sent
*  --------------------+------------------------------------------------------------
*  SHIFTDOWN           | Hold Shift down until SHIFTUP is sent
*  --------------------+------------------------------------------------------------
*  CTRLDOWN            | Hold CTRL down until CTRLUP is sent
*  --------------------+------------------------------------------------------------
*  LWINDOWN            | Hold the left Windows key down until LWDINUP is sent
*  --------------------+------------------------------------------------------------
*  RWINDOWN            | Hold the right Windows key down until RWINUP is sent
*  --------------------+------------------------------------------------------------
*  ASC nnnn            | Send the kombination Alt+nnnn on numpad
*  --------------------+------------------------------------------------------------
*  BROWSER_BACK        | 2000/XP Only: Select the browser "back" button
*  --------------------+------------------------------------------------------------
*  BROWSER_FORWARD     | 2000/XP Only: Select the browser "forward" button
*  --------------------+------------------------------------------------------------
*  BROWSER_REFRESH     | 2000/XP Only: Select the browser "refresh" button
*  --------------------+------------------------------------------------------------
*  BROWSER_STOP        | 2000/XP Only: Select the browser "stop" button
*  --------------------+------------------------------------------------------------
*  BROWSER_SEARCH      | 2000/XP Only: Select the browser "search" button
*  --------------------+------------------------------------------------------------
*  BROWSER_FAVORITES   | 2000/XP Only: Select the browser "favorites" button
*  --------------------+------------------------------------------------------------
*  BROWSER_HOME        | 2000/XP Only: Launch the browser and go to the home page
*  --------------------+------------------------------------------------------------
*  VOLUME_MUTE         | 2000/XP Only: Mute the volume
*  --------------------+------------------------------------------------------------
*  VOLUME_DOWN         | 2000/XP Only: Reduce the volume
*  --------------------+------------------------------------------------------------
*  VOLUME_UP           | 2000/XP Only: Increase the volume
*  --------------------+------------------------------------------------------------
*  MEDIA_NEXT          | 2000/XP Only: Select next track in media player
*  --------------------+------------------------------------------------------------
*  MEDIA_PREV          | 2000/XP Only: Select previous track in media player
*  --------------------+------------------------------------------------------------
*  MEDIA_STOP          | 2000/XP Only: Stop media player
*  --------------------+------------------------------------------------------------
*  MEDIA_PLAY_PAUSE    | 2000/XP Only: Play/pause media player
*  --------------------+------------------------------------------------------------
*  LAUNCH_MAIL         | 2000/XP Only: Launch the email application
*  --------------------+------------------------------------------------------------
*  LAUNCH_MEDIA        | 2000/XP Only: Launch media player
*  --------------------+------------------------------------------------------------
*  LAUNCH_APP1         | 2000/XP Only: Launch user app1
*  --------------------+------------------------------------------------------------
*  LAUNCH_APP2         | 2000/XP Only: Launch user app2
*
*A "!" in +keys+ indicates an ALT keystroke, 
*the "+" means SHIFT, "^" CTRL 
*and "#" is the Windows key. 
*/

//--
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//END DOCUMENTATION keyboard.c
//BEGIN DOCUMENTATION mouse.c
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//++

/*
*Document-method: AutoItX3.mouse_click
*
*call-seq: 
*  AutoItX3.mouse_click( [x [, y [, button [, clicks [speed ] ] ] ] ) ==> nil
*  AutoItX3.click_mouse( [x [, y [, button [, clicks [speed ] ] ] ] ) ==> nil
*
*====Arguments
*- x (INTDEFAULT): The X position. The cursor's current X if not specified. 
*- y (INTDEFAULT): The Y position. The cursor's current Y if not specified. 
*- button("Primary"): The mouse button to click width. On a mouse for left-handed people the right, for right-handed people the left mouse button. 
*- clicks(1): The number of times to click. 
*- speed(10): The speed the mouse cursor will move with. If set to 0, the cursor is set immediatly. 
*
*Clicks the mouse. 
*/

/*
*Document-method: AutoItX3.drag_mouse
*
*call-seq: 
*  AutoItX3.drag_mouse(x1, y1, x2, y2 [, button [, speed ] ] ) ==> nil
*
*Performes a drag & drop operation with the given parameters. 
*/

/*
*Document-method: AutoItX3.hold_mouse_down
*
*call-seq: 
*  AutoItX3.hold_mouse_down( [ button = "Primary" ] ) ==> nil
*  AutoItX3.mouse_down( [ button = "Primary" ] ) ==> nil
*
*Holds a mouse button down (the left by default, or the right if mouse buttons are swapped). 
*You should release the mouse button somewhen. 
*/

/*
*Document-method: AutoItX3.cursor_id
*
*call-seq: 
*  AutoItX3.cursor_id ==> aFixnum
*  AutoItX3.get_cursor_id ==> aFixnum
*
*Returns one of the *_CURSOR constants to indicate which cursor icon is actually shown. 
*/

/*
*Document-method: AutoItX3.cursor_pos
*
*call-seq: 
*  AutoItX3.cursor_pos ==> anArray
*  AutoItX3.get_cursor_pos ==> anArray
*
*Returns the current cursor position in a two-element array of form <tt>[x, y]</tt>. 
*/

/*
*Document-method: AutoItX3.move_mouse
*
*call-seq: 
*  AutoItX3.move_mouse( x , y [, speed = 10 ] ) ==> nil
*  AutoItX3.mouse_move( x , y [, speed = 10 ] ) ==> nil
*
*Moves the mouse cursor to the given position. If +speed+ is 0, 
*it's set immediately. 
*/

/*
*Document-method: AutoItX3.release_mouse
*
*call-seq: 
*  AutoItX3.release_mouse( [ button = "Primary" ] ) ==> nil
*  AutoItX3.mouse_up( [ button = "Primary" ] ) ==> nil
*
*Releases a mouse button hold down by #hold_mouse_down. 
*/

/*
*Document-method: AutoItX3.mouse_wheel
*
*call-seq: 
*  AutoItX3.mouse_wheel( direction [, times = 5] ) ==> nil
*
*Scrolls up or down the mouse wheel +times+ times. Use 
*ether "Up" or "Down" as the value for +direction+. 
*/

//--
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//END DOCUMENTATION mouse.c
//BEGIN DOCUMENTATION process.c
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//++

/*
*Document-method: AutoItX3.close_process
*
*call-seq: 
*  AutoItX3.close_process( pid ) ==> nil
*  AutoItX3.kill_process( pid ) ==> nil
*
*Closes the given process. 
*/

/*
*Document-method: AutoItX3.process_exists?
*
*call-seq: 
*  AutoItX3.process_exists?( pid ) ==> anInteger or false
*
*Checks wheather or not the given name or PID exists. If successful, 
*this method returns the PID of the process. 
*/

/*
*Document-method: AutoItX3.set_process_priority
*
*call-seq: 
*  AutoItX3.set_process_priority( pid , priority ) ==> priority
*
*Sets a process's priority. Use one of the *_PRIORITY constants. 
*/

/*
*Document-method: AutoItX3.wait_for_process
*
*call-seq: 
*  AutoItX3.wait_for_process( procname [, timeout ] ) ==> true or false
*
*Waits for the given process name to exist. This is the only process-related 
*method that doesn't take a PID, because to wait for a special PID doesn't make 
*sense, since PIDs are generated randomly. 
*/

/*
*Document-method: AutoItX3.wait_for_process_close
*
*call-seq: 
*  AutoItX3.wait_for_process_close( pid [, timeout ] ) ==> true or false
*
*Waits for the given process name or PID to disappear. 
*/

/*
*Document-method: AutoItX3.run
*
*call-seq: 
*  AutoItX3.run( name [, workingdir [, flag ] ] ) ==> einInteger or nil
*
*Runs a program. The program flow continues, if you want to wait for the process to 
*finish, use #run_and_wait. 
*Returns the PID of the created process or nil if there was a failure starting the process. 
*The +flag+ parameter can be one of the HIDE, MINIMZE or MAXIMIZE constants. 
*/

/*
*Document-method: AutoItX3.run_and_wait
*
*call-seq: 
*  AutoItX3.run_and_wait( name [, workingdir [, flag ] ] ) ==> einInteger or nil
*
*Runs a program. This method waits until the process has finished and returns 
*the exitcode of the process (or false if there was an error initializing it). If 
*you don't want this behaviour, use #run. 
*The +flag+ parameter can be one of the HIDE, MINIMZE or MAXIMIZE constants. 
*/

/*
*Document-method: AutoItX3.run_as_set
*
*call-seq: 
*  AutoItX3.run_as_set( username , domain , password [, options ] ) ==> true
*
*Changes the the owner of following  #run and #run_and_wait methods to the given 
*user. Raises a NotImplementedError if your system is Win2000 or older. 
*/

/*
*Document-method: AutoItX3.shutdown
*
*call-seq: 
*  AutoItX3.shutdown( code ) ==> true or false
*
*Executes one of the the following commands: 
*- SHUTDOWN
*- REBOOT
*- LOGOFF
*You can combine the above actions with the below constants, except 
*LOGOFF and POWER_DOWN. Use the + operator to combine them. 
*- FORCE_CLOSE
*- POWER_DOWN
*/

//--
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//END DOCUMENTATION process.c
//BEGIN DOCUMENTATION window.c
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//++

/*
*Document-method: AutoItX3::Window.new
*
*call-seq: 
*  AutoItX3::Window.new( title [, text = "" ] ) ==> aWindow
*
*Creates a new Window object. This method checks if a window 
*with the given properties exists (via Window.exists?) and raises 
*an Au3Error if it does not. Use Window::DESKTOP_WINDOW as 
*the +title+ to get a window describing the desktop. Use Window::ACTIVE_WINDOW 
*as the +title+ to get a window describing the active (foreground) window. 
*/

/*
*Document-method: AutoItX3::Window.exists?
*
*call-seq: 
*  AutoItX3::Window.exists?( title [, text = "" ] ) ==> true or false
*
*Checks if a window with the given properties exists. 
*/

/*
*Document-method: AutoItX3::Window.caret_pos
*
*call-seq: 
*  AutoItX3::Window.caret_pos ==> anArray
*
*Returns a two-element array of form <tt>[x , y]</tt> reflecting the 
*position of the caret in the active window. This doesn't work with 
*every window. 
*/

/*
*Document-method: AutoItX3::Window.minimize_all
*
*call-seq: 
*  AutoItX3::Window.minimize_all ==> nil
*
*Minimizes all available windows. 
*/

/*
*Document-method: AutoItX3::Window.undo_minimize_all
*
*call-seq: 
*  AutoItX3::Window.undo_minimize_all ==> nil
*
*Undoes a previous call to Window.minimize_all. 
*/

/*
*Document-method: AutoItX3::Window.wait
*
*call-seq: 
*  AutoItX3::Window.wait( title [, text [, timeout ] ] ) ==> true or false )
*
*Waits for a window with the given properties to exist. You may 
*specify a +timeout+ in seconds. +wait+ normally returns true, but if 
*the timeout is expired, it returns false. 
*/

/*
*Document-method: AutoItX3::Window#inspect
*
*call-seq: 
*  AutoItX3::Window#inspect ==> aString
*
*Human-readable output of form <tt>"<Window: WINDOW_TITLE (WINDOW_HANDLE)>"</tt>. 
*The title is determined by calling #title. 
*/

/*
*Document-method: AutoItX3::Window#to_s
*
*call-seq: 
*  AutoItX3::Window#to_s ==> aString
*
*Returns +self+'s title. 
*/

/*
*Document-method: AutoItX3::Window#to_i
*
*call-seq: 
*  AutoItX3::Window#to_i ==> anInteger
*
*Returns the handle of the window as an integer by calling 
*<tt>.to_i(16)</tt> on the result of #handle. 
*/

/*
*Document-method: AutoItX3::Window#activate
*
*call-seq: 
*  AutoItX3::Window#activate ==> true or false
*
*Activates the window and returns true if it was successfully activated. 
*/

/*
*Document-method: AutoItX3::Window#active?
*
*call-seq: 
*  AutoItX3::Window#active? ==> true or false
*
*Checks wheather or not the window is active. 
*/

/*
*Document-method: AutoItX3::Window.close
*
*call-seq: 
*  AutoItX3::Window#close ==> nil
*
*Sends WM_CLOSE to +self+. WM_CLOSE may be processed by the window, 
*it could, for example, ask to save or the like. If you want to kill a window 
*without giving the ability to process your message, use the #kill method. 
*/

/*
*Document-method: AutoItX3::Window#exists?
*
*call-seq: 
*  AutoItX3::Window#exists? ==> true or false
*
*Calls the Window.exists? class method with the values given in Window.new. 
*/

/*
*Document-method: AutoItX3::Window#class_list
*
*call-seq: 
*  AutoItX3::Window#class_list ==> anArray
*
*Returns an array of all used window classes of +self+. 
*/

/*
*Document-method: AutoItX3::Window#client_size
*
*call-seq: 
*  AutoItX3::Window#client_size ==> anArray
*
*Returns the client area size of +self+ as a two-element array of 
*form <tt>[ width , height ]</tt>. Returns <tt>[0, 0]</tt> on minimized 
*windows. 
*/

/*
*Document-method: AutoItX3::Window#handle
*
*call-seq: 
*  AutoItX3::Window#handle ==> aString
*
*Returns the numeric handle of a window as a string. It can be used 
*with the WinTitleMatchMode option set to advanced or for direct calls 
*to the windows API (but you have to call <tt>.to_i(16)</tt> on the string then). 
*/

/*
*Document-method: AutoItX3::Window#rect
*
*call-seq: 
*  AutoItX3::Window#rect ==> anArray
*
*Returns the position and size of +self+ in a four-element array 
*of form <tt>[x, y, width, height]</tt>. 
*/

/*
*Document-method: AutoItX3::Window#pid
*
*call-seq: 
*  AutoItX3::Window#pid ==> anInteger
*
*Returns the process identification number of +self+'s window 
*procedure. 
*/

/*
*Document-method: AutoItX3::Window#visible?
*
*call-seq: 
*  AutoItX3::Window#visible? ==> true or false
*
*Returns true if +self+ is shown on the screen. 
*/

/*
*Document-method: AutoItX3::Window#enabled?
*
*call-seq: 
*  AutoItX3::Window#enabled? ==> true or false
*
*Returns true if +self+ is enabled (i.e. it can receive input). 
*/

/*
*Document-method: AutoItX3::Window#minimized?
*
*call-seq: 
*  AutoItX3::Window#minimized? ==> true or false
*
*Returns true if +self+ is minimized to the taskbar. 
*/

/*
*Document-method: AutoItX3::Window#maximized?
*
*call-seq: 
*  AutoItX3::Window#maximized? ==> true or false
*
*Returns true if +self+ is maximized to full screen size. 
*/

/*
*Document-method: AutoItX3::Window#state
*
*call-seq: 
*  AutoItX3::Window#state ==> anInteger
*
*Returns the integer composition of the states 
*- exists (1)
*- visible (2)
*- enabled (4)
*- active (8)
*- minimized (16)
*- maximized (32)
*Use the bit-wise AND operator & to check for a specific state. 
*Or just use one of the predefined methods #exists?, #visible?, 
*#enabled?, #active?, #minimized? and #maximized?. 
*/

/*
*Document-method: AutoItX3::Window#text
*
*call-seq: 
*  AutoItX3::Window#text ==> aString
*
*Returns the text read from a window. This method does not 
*affect the @text instance variable, it's a call to the AutoItX3 
*function <i>WinGetText</i>. 
*/

/*
*Document-method: AutoItX3::Window#title
*
*call-seq: 
*  AutoItX3::Window#title ==> aString
*
*Returns the title read from a window. This method does not 
*affect or even use the value of @title, that means you can use 
*+title+ to retrieve titles from a window if you're working with the 
*advanced window mode. 
*/

/*
*Document-method: AutoItX3::Window#kill
*
*call-seq: 
*  AutoItX3::Window#kill ==> true or false
*
*Kills +self+. This method forces a window to close if it doesn't close 
*quickly enough (in contrary to #close which waits for user actions 
*if neccessary). Some windows cannot be +kill+ed (notably 
*Windows Explorer windows). 
*/

/*
*Document-method: AutoItX3::Window.select_menu_item
*
*call-seq: 
*  AutoItX3::Window#select_menu_item( menu [, *items ] ) ==> nil
*
*Clicks the specified item in the specified menu. You may specify up to seven 
*submenus. 
*TODO: This function doesn't find any item and so raises an Au3Error. 
*/

/*
*Document-method: AutoItX3::Window#move
*
*call-seq: 
*  AutoItX3::Window#move( x , y [, width [, height ] ] ) ==> nil
*
*Moves a window (and optionally resizes it). This does not work 
*with minimized windows. 
*/

/*
*Document-method: AutoItX3::Window#set_on_top=
*
*call-seq: 
*  AutoItX3::Window#set_on_top = val ==> val
*
*Turn the TOPMOST flag of +self+ on or off. If activated, the window 
*will stay on top over all other windows. 
*/

/*
*Document-method: AutoItX3::Window#state=
*
*call-seq: 
*  AutoItX3::Window#state = val ==> val
*
*Sets +self+'s window state to one of the SW_* constants. 
*/

/*
*Document-method: AutoItX3::Window#title=
*
*call-seq: 
*  AutoItX3::Window#title = val ==> val
*
*Renames +self+. This does not change the internal @title 
*instance variable, so you can use this with the 
*advanced window mode. 
*/

/*
*Document-method: AutoItX3::Window#trans=
*
*call-seq: 
*  AutoItX3::Window#trans = val ==> val
*  AutoItX3::Window#transparency = val ==> val
*
*Sets the transparency of +self+ or raises a NotImplementedError 
*if the OS is Windows Millenium or older. 
*/

/*
*Document-method: AutoItX3::Window#wait
*
*call-seq: 
*  AutoItX3::Window#wait( [ timeout = 0 ] ) ==> true or false
*
*Waits for +self+ to exist. This method calls Window's class 
*method wait, so see Window.wait for more information. 
*/

/*
*Document-method: AutoItX3::Window#wait_active
*
*call-seq: 
*  AutoItX3::Window#wait_active( [ timeout = 0 ] ) ==> true or false
*
*Waits for +self+ to be the active (that is, have the input focus). 
*/

/*
*Document-method: AutoItX3::Window#wait_close
*
*call-seq: 
*  AutoItX3::Window#wait_close( [timeout = 0] ) ==> true or false
*
*Waits for +self+ to be closed. 
*/

/*
*Document-method: AutoItX3::Window#wait_not_active
*
*call-seq: 
*  AutoItX3::Window#wait_not_active( [ timeout = 0 ] ) ==> true or false
*
*Waits for +self+ to lose the input focus. 
*/

/*
*Document-method: AutoItX3::Window#focused_control
*
*call-seq: 
*  AutoItX3::Window#focused_control ==> aControl
*
*Returns the actually focused control in +self+, a AutoItX3::Control object. 
*/

/*
*Document-method: AutoItX3::Window#statusbar_text
*
*call-seq: 
*  AutoItX3::Window#statusbar_text( [ part = 1 ] ) ==> aString
*
*Reads the text of the statusbar at position +part+. This method 
*raises an Au3Error if there's no statusbar, it's not a mscommon 
*statusbar or if you try to read a position out of range. 
*/

//--
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//END DOCUMENTATION window.c
//BEGIN DOCUMENTATION control.c
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//++

/*
*Document-method: AutoItX3::Control.new
*
*call-seq: 
*  AutoItX3::Control.new( title , text , control_id ) ==> aControl
*
*Creates a new Control object. Pass in the title and text of 
*the window holding the control (or "" if you don't want to specify one of them) 
*and the ID of the control. Instead of the ID you may use the name of the 
*control in combination width the occurence number of it, like "Edit1" and "Edit2". 
*/

/*
*Document-method: AutoItX3::Control#click
*
*call-seq: 
*  AutoItX3::Control#click( [ button [, clicks [, x [, y ] ] ] ] ) ==> true
*
*Clicks +self+ with the given mouse +button+ (<tt>"Primary"</tt> by default) 
*+click+ times (1 by default) at the given position (middle by default). 
*/

/*
*Document-method: AutoItX3::Control#disable
*
*call-seq: 
*  AutoItX3::Control#disable ==> true
*
*Disables ("grays out") +self+. 
*/

/*
*Document-method: AutoItX3::Control#enable
*
*call-seq: 
*  AutoItX3::Control#enable ==> true
*
*Enables +self+ (i.e. make it accept user actions). 
*/

/*
*Document-method: AutoItX3::Control#focus
*
*call-seq: 
*  AutoItX3::Control#focus ==> true
*
*Gives the input focus to +self+. 
*/

/*
*Document-method: AutoItX3::Control#handle
*
*call-seq: 
*  AutoItX3::Control#handle ==> aString
*
*Returns the internal window handle of +self+. It can be used in 
*advanced window mode or directly in Win32 API calls (but you have 
*to call #to_i on the string than). 
*/

/*
*Document-method: AutoItX3::Control#rect
*
*call-seq: 
*  AutoItX3::Control#rect ==> anArray
*
*Returns a 4-element array containing the control's position and size. 
*Form is: <tt>[ x , y , width , height ]</tt>. 
*/

/*
*Document-method: AutoItX3::Control#text
*
*call-seq: 
*  AutoItX3::Control#text ==> aString
*
*Returns the +self+'s text. 
*/

/*
*Document-method: AutoItX3::Control#move
*
*call-seq: 
*  AutoItX3::Control#move( x , y [, width [, height ] ] ) ==> true
*
*Moves a control and optionally resizes it. 
*/

/*
*Document-method: AutoItX3::Control#send_keys
*
*call-seq: 
*  AutoItX3::Control#send_keys( str [, flag = 0 ] ) ==> true
*
*Simulates user input to a control. This works normally even on 
*hidden and inactive windows. Please note that this method cannot 
*send every keystroke AutoItX3.send_keys can, notably [ALT] combinations. 
*/

/*
*Document-method: AutoItX3::Control#text=
*
*call-seq: 
*  AutoItX3::Control#text = str ==> str
*
*Sets the text of a control directly. 
*/

/*
*Document-method: AutoItX3::Control#show
*
*call-seq: 
*  AutoItX3::Control#show ==> true
*
*Shows a hidden control. 
*/

/*
*Document-method: AutoItX3::Control#send_command_to_control
*
*call-seq: 
*  AutoItX3::Control#send_command_to_control( command [, arg ] ) ==> aString
*
*Sends a command to a control. You won't need to use this method, since all commands 
*are wrapped into methods. It's only used internally. 
*/

/*
*Document-method: AutoItX3::Control#visible?
*
*call-seq: 
*  AutoItX3::Control#visible? ==> true or false
*
*Returns wheather or not a control is visible. 
*/

/*
*Document-method: AutoItX3::Control#enabled?
*
*call-seq: 
*  AutoItX3::Control#enabled? ==> true or false
*
*Returns true if a control can interact with the user (i.e. it's not "grayed out"). 
*/

//--
//ListBox class
//++

/*
*Document-method: AutoItX3::ListBox#<<
*
*call-seq: 
*  AutoItX3::ListBox#add( item ) ==> item
*  AutoItX3::ListBox#<< item ==> self
*
*Adds an entry to an existing combo or list box. 
*If you use the << form, you can do a chain call like: 
*  ctrl << "a" << "b" << "c"
*/

/*
*Document-method: AutoItX3::ListBox#delete
*
*call-seq: 
*  AutoItX3::ListBox#delete( no ) ==> item
*
*Delete item +no+. 
*/

/*
*Document-method: AutoItX3::ListBox#find
*
*call-seq: 
*  AutoItX3::ListBox#find( item ) ==> anInteger
*
*Finds the item number of +item+ in +self+. 
*/

/*
*Document-method: AutoItX3::ListBox#current_selection=
*
*call-seq: 
*  AutoItX3::ListBox#current_selection = num ==> num
*
*Sets the current selection of a combo box to item +num+. 
*/

/*
*Document-method: AutoItX3::ListBox#select_string
*
*call-seq: 
*  AutoItX3::ListBox#select_string( str ) ==> str
*
*Sets +self+'s selection to the first occurence of +str+. 
*/

/*
*Document-method: AutoItX3::ListBox#current_selection
*
*call-seq: 
*  AutoItX3::ListBox#current_selection ==> aString
*
*Returns the currently selected string. 
*/

//--
//ComboBox class
//++

/*
*Document-method: AutoItX3::ComboBox#drop
*
*call-seq: 
*  AutoItX3::ComboBox#drop ==> true
*
*Drops down a combo box. 
*/

/*
*Document-method: AutoItX3::ComboBox#undrop
*
*call-seq: 
*  AutoItX3::ComboBox#undrop ==> true
*  AutoItX3::ComboBox#close ==> true
*
*Undrops or closes a combo box. 
*/

//--
//Button class
//++

/*
*Document-method: AutoItX3::Button#checked?
*
*call-seq: 
*  AutoItX3::Button#checked? ==> true or false
*
*Returns wheather +self+ is checked or not. 
*Only useful for radio and check buttons. 
*/

/*
*Document-method: AutoItX3::Button#check
*
*call-seq: 
*  AutoItX3::Button#check ==> true
*
*Checks +self+ if it's a radio or check button. 
*/

/*
*Document-method: AutoItX3::Button#uncheck
*
*call-seq: 
*  AutoItX3::Button#uncheck ==> true
*
*Unchecks +self+ if it's a radio or check button. 
*/

//--
//Edit class
//++

/*
*Document-method: AutoItX3::Edit#caret_pos
*
*call-seq: 
*  AutoItX3::Edit#caret_pos ==> anArray
*
*Returns the current caret position in a 2-element array 
*of form <tt>[line, column]</tt>. 
*/

/*
*Document-method: AutoItX3::Edit#lines
*
*call-seq: 
*  AutoItX3::Edit#lines ==> anInteger
*
*Returns the number of lines in +self+. 
*/

/*
*Document-method: AutoItX3::Edit#selected_text
*
*call-seq: 
*  AutoItX3::Edit#selected_text ==> aString
*
*Returns the currently selected text. 
*/

/*
*Document-method: AutoItX3::Edit#paste
*
*call-seq: 
*  AutoItX3::Edit#paste( str ) ==> str
*
*"Pastes" +str+ at +self+'s current caret position. 
*/

//--
//TabBook class
//++

/*
*Document-method: AutoItX3::TabBook#current
*
*call-seq: 
*  AutoItX3::TabBook#current ==> anInteger
*
*Returns the currently shown tab. 
*/

/*
*Document-method: AutoItX3::TabBook#right
*
*call-seq: 
*  AutoItX3::TabBook#right ==> anInteger
*
*Shows the tab right to the current one and returns the number 
*of the now shown tab. 
*/

/*
*Document-method: AutoItX3::TabBook#left
*
*call-seq: 
*  AutoItX3::TabBook#left ==> anInteger
*
*Shows the tab left to the current one and returns the number 
*of the now shown tab. 
*/

//--
//ListView class
//++

/*
*Document-method: AutoItX3::ListView#send_command_to_list_view
*
*call-seq: 
*  AutoItX3::ListView#send_command_to_list_view( cmd [, arg1 [, arg2 ] ] ) ==> aString
*
*Sends +cmd+ to +self+. This method is only used internally. 
*/

/*
*Document-method: AutoItX3::ListView#deselect
*
*call-seq: 
*  AutoItX3::ListView#deselect( from [, to ] ) ==> nil
*
*Deselects the given item(s). 
*/

/*
*Document-method: AutoItX3::ListView#find
*
*call-seq: 
*  AutoItX3::ListView#find( string [, sub_item ] ) ==> anInteger or false
*
*Searches for +string+ and +sub_item+ in +self+ and returns the index 
*of the found list item or false if it isn't found. 
*/

/*
*Document-method: AutoItX3::ListView#item_count
*
*call-seq: 
*  AutoItX3::ListView#item_count ==> anInteger
*  AutoItX3::ListView#size ==> anInteger
*  AutoItX3::ListView#length ==> anInteger
*
*Returns the number of items in +self+. 
*/

/*
*Document-method: AutoItX3::ListView#selected
*
*call-seq: 
*  AutoItX3::ListView#selected ==> anArray
*
*Returns the inices of the selected items in an array which is empty if 
*none is selected. 
*/

/*
*Document-method: AutoItX3::ListView#num_selected
*
*call-seq: 
*  AutoItX3::ListView#selected_num ==> anInteger
*
*Returns the number of selected items. 
*/

/*
*Document-method: AutoItX3::ListView#num_subitems
*
*call-seq: 
*  AutoItX3::ListView#subitem_num ==> anInteger
*
*Returns the number of subitems in +self+. 
*/

/*
*Document-method: AutoItX3::ListView#text_at
*
*call-seq: 
*  AutoItX3::ListView#text_at( item [, subitem ] ) ==> aString
*  AutoItX3::ListView#[ item [, subitem ] ] ==> aString
*
*Returns the text at the given position. 
*/

/*
*Document-method: AutoItX3::ListView#selected?
*
*call-seq: 
*  AutoItX3::ListView#selected?( item ) ==> true or false
*
*Returns wheather or not +item+ is selected. 
*/

/*
*Document-method: AutoItX3::ListView#select
*
*call-seq: 
*  AutoItX3::ListView#select( from [, to ] ) ==> nil
*
*Selects the given item(s). 
*/

/*
*Document-method: AutoItX3::ListView#select_all
*
*call-seq: 
*  AutoItX3::ListView#select_all ==> nil
*
*Selects all items in +self+. 
*/

/*
*Document-method: AutoItX3::ListView#clear_selection
*
*call-seq: 
*  AutoItX3::ListView#clear_selection ==> nil
*  AutoItX3::ListView#select_none ==> nil
*
*Clears the selection. 
*/

/*
*Document-method: AutoItX3::ListView#invert_selection
*
*call-seq: 
*  AutoItX3::ListView#invert_selection ==> nil
*
*Inverts the selection. 
*/

/*
*Document-method: AutoItX3::ListView#change_view
*
*call-seq: 
*  AutoItX3::ListView#change_view( view ) ==> view
*
*Changes the view of +self+. Possible values of +view+ are 
*all constants of the ListView class. 
*/

//--
//TreeView class
//++

/*
*Document-method: AutoItX3::TreeView#send_command_to_tree_view
*
*call-seq: 
*  AutoItX3::TreeView#send_command_to_tree_view( cmd [, arg1 [, arg2 ] ] ) ==> aString
*
*Sends +cmd+ to +self+. This method is only used internally. 
*/

/*
*Document-method: AutoItX3::TreeView#check
*
*call-seq: 
*  AutoItX3::TreeView#check( item ) ==> nil
*
*Checks +item+ if it supports that operation. 
*/

/*
*Document-method: AutoItX3::TreeView#collapse
*
*call-seq: 
*  AutoItX3::TreeView#collapse( item ) ==> nil
*
*Collapses +item+ to hide its children. 
*/

/*
*Document-method: AutoItX3::TreeView#exists?
*
*call-seq: 
*  AutoItX3::TreeView#exists?( item ) ==> true or false
*
*Return wheather or not +item+ exists. 
*/

/*
*Document-method: AutoItX3::TreeView#expand
*
*call-seq: 
*  AutoItX3::TreeView#expand( item ) ==> nil
*
*Expands +item+ to show its children. 
*/

/*
*Document-method: AutoItX3::TreeView#num_subitems
*
*call-seq: 
*  AutoItX3::TreeView#num_subitems( item ) ==> anInteger
*
*Returns the number of children of +item+. 
*/

/*
*Document-method: AutoItX3::TreeView#selected
*
*call-seq: 
*  AutoItX3::TreeView#selected( use_index = false ) ==> aString or anInteger
*
*Returns the text reference or the index reference (if +use_index+ is true) of 
*the selected item. 
*/

/*
*Document-method: AutoItX3::TreeView#text_at
*
*call-seq: 
*  AutoItX3::TreeView#text_at( item ) ==> aString
*  AutoItX3::TreeView#[ item ] ==> aString
*
*Returns the text of +item+. 
*/

/*
*Document-method: AutoItX3::TreeView#checked?
*
*call-seq: 
*  AutoItX3::TreeView#checked?( item ) ==> true or false
*
*Returns wheather or not +item+ is checked. Raises an Au3Error 
*if +item+ is not a checkbox. 
*/

/*
*Document-method: AutoItX3::TreeView#select
*
*call-seq: 
*  AutoItX3::TreeView#select( item ) ==> nil
*
*Selects +item+. 
*/

/*
*Document-method: AutoItX3::TreeView#uncheck
*
*call-seq: 
*  AutoItX3::TreeView#uncheck( item ) ==> nil
*
*Unchecks +item+ if it suports that operation (i.e. it's a checkbox). 
*/

//--
//================================================================
//END DOCUMENTATION
//================================================================
//++

#define _CRT_SECURE_NO_DEPRECATE //Warnungen in MSVC ausblenden
//Einbinden von Systembibliotheken 
#include <stdio.h>
#include <string.h>
#include "Ruby.h"
#include "AutoIt3.h"

//Definieren des AutoItX3-Moduls
static VALUE AutoItX3 = Qnil;
//Die Errorklasse dieser Library
static VALUE Au3Error = Qnil;
//Klasse für Window-Objekte
static VALUE Window = Qnil;
//Klasse für Control-Objekte
static VALUE Control = Qnil;
//Klasse für ListBoxen
static VALUE ListBox = Qnil;
//Klasse für ComboBoxen
static VALUE ComboBox = Qnil;
//Klasse für Radio-, Check- und normale Buttons
static VALUE Button = Qnil;
//Klasse für Textcontrols (Edits)
static VALUE Edit = Qnil;
//Klasse für SysTabControl32-Controls
static VALUE TabBook = Qnil;
//Klasse für ListView32-Controls
static VALUE ListView = Qnil;
//Klasse für TreeView32-Controls
static VALUE TreeView = Qnil;

//Einbinden eigener Bibliotheken
#include "parts/wconv.c"
#include "parts/utils.c"
//Einbinden der Programmteile
#include "parts/misc.c"
#include "parts/filedir.c"
#include "parts/graphic.c"
#include "parts/keyboard.c"
#include "parts/mouse.c"
#include "parts/process.c"
#include "parts/window.c"
#include "parts/control.c"

//Ruby-Initialisierungsfunktion
void Init_au3(void)
{
  VALUE au3single = Qnil;
  //--
  //========================================================
  //Erstellen von Klassen und Modulen
  //========================================================
  //++
  AutoItX3 = rb_define_module("AutoItX3");
  au3single = rb_singleton_class(AutoItX3); //Singletonklasse
  Au3Error = rb_define_class_under(AutoItX3, "Au3Error", rb_eStandardError);
  Window = rb_define_class_under(AutoItX3, "Window", rb_cObject);
  Control = rb_define_class_under(AutoItX3, "Control", rb_cObject);
  ListBox = rb_define_class_under(AutoItX3, "ListBox", Control);
  ComboBox = rb_define_class_under(AutoItX3, "ComboBox", ListBox);
  Button = rb_define_class_under(AutoItX3, "Button", Control);
  Edit = rb_define_class_under(AutoItX3, "Edit", Control);
  TabBook = rb_define_class_under(AutoItX3, "TabBook", Control);
  ListView = rb_define_class_under(AutoItX3, "ListView", Control);
  TreeView = rb_define_class_under(AutoItX3, "TreeView", Control);
  
  //--
  //========================================================
  //Definieren von Konstanten
  //========================================================
  //++
  
  /*The smallest value AutoIt can handle. Used for *some* parameter defaults. */
  rb_define_const(AutoItX3, "INTDEFAULT", INT2NUM(-2147483647));
  /*The version of the AutoItX-Ruby API. */
  rb_define_const(AutoItX3, "VERSION", rb_str_new2("0.0.1"));
  
  /*Unknown cursor icon*/
  rb_define_const(AutoItX3, "UNKNOWN_CURSOR", INT2FIX(0));
  /*Application starting cursor (arrow with a hourglass next to it)*/
  rb_define_const(AutoItX3, "APP_STARTING_CURSOR", INT2FIX(1));
  /*The normal cursor*/
  rb_define_const(AutoItX3, "ARROW_CURSOR", INT2FIX(2));
  /*Cross cursor*/
  rb_define_const(AutoItX3, "CROSS_CURSOR", INT2FIX(3));
  /*Cursor with a question mark next to it*/
  rb_define_const(AutoItX3, "HELP_CURSOR", INT2FIX(4));
  /*Cursor for editing lines of text*/
  rb_define_const(AutoItX3, "IBEAM_CURSOR", INT2FIX(5));
  rb_define_const(AutoItX3, "ICON_CURSOR", INT2FIX(6));
  /*Cursor for forbidden actions (a circle with a strike through it)*/
  rb_define_const(AutoItX3, "NO_CURSOR", INT2FIX(7));
  rb_define_const(AutoItX3, "SIZE_CURSOR", INT2FIX(8));
  rb_define_const(AutoItX3, "SIZE_ALL_CURSOR", INT2FIX(9));
  rb_define_const(AutoItX3, "SIZE_NESW_CURSOR", INT2FIX(10));
  rb_define_const(AutoItX3, "SIZE_NS_CURSOR", INT2FIX(11));
  rb_define_const(AutoItX3, "SIZE_NWSE_CURSOR", INT2FIX(12));
  rb_define_const(AutoItX3, "SIZE_WE_CURSOR", INT2FIX(13));
  rb_define_const(AutoItX3, "UP_ARROW_CURSOR", INT2FIX(14));
  /*Wait (the well-known "hourglass")*/
  rb_define_const(AutoItX3, "WAIT_CURSOR", INT2FIX(15));
  /*Lowest process priorety*/
  rb_define_const(AutoItX3, "IDLE_PRIORETY", INT2FIX(0));
  /*Subnormal process priority*/
  rb_define_const(AutoItX3, "SUBNORMAL_PRIORITY", INT2FIX(1));
  /*Normal process priority*/
  rb_define_const(AutoItX3, "NORMAL_PRIORITY", INT2FIX(2));
  /*Process priority above normal*/
  rb_define_const(AutoItX3, "SUPNORMAL_PRIORITY", INT2FIX(3));
  /*High process priority*/
  rb_define_const(AutoItX3, "HIGH_PRIORITY", INT2FIX(4));
  /*Highest process priority. Use this with caution, it's is the priority system processes run with.*/
  rb_define_const(AutoItX3, "REALTIME_PRIORITY", INT2FIX(5));
  /*Logs the currect user out*/
  rb_define_const(AutoItX3, "LOGOFF", INT2FIX(0));
  /*Shuts the computer down*/
  rb_define_const(AutoItX3, "SHUTDOWN", INT2FIX(1));
  /*Reboot the computer*/
  rb_define_const(AutoItX3, "REBOOT", INT2FIX(2));
  /*Force hanging applications to close*/
  rb_define_const(AutoItX3, "FORCE_CLOSE", INT2FIX(4));
  /*Turn the power off after shutting down (if the computer supports this)*/
  rb_define_const(AutoItX3, "POWER_DOWN", INT2FIX(8));
  /*A window describing the desktop*/
  rb_define_const(Window, "DESKTOP_WINDOW", rb_str_new2("Program Manager"));
  /*A window describing the active (foreground) window*/
  rb_define_const(Window, "ACTIVE_WINDOW", rb_str_new2(""));
  /*Hide the window*/
  rb_define_const(Window, "SW_HIDE", LONG2NUM(SW_HIDE));
  /*Show the window*/
  rb_define_const(Window, "SW_SHOW", LONG2NUM(SW_SHOW));
  /*Minimize the window*/
  rb_define_const(Window, "SW_MINIMIZE", LONG2NUM(SW_MINIMIZE));
  /*Maximize the window*/
  rb_define_const(Window, "SW_MAXIMIZE", LONG2NUM(SW_MAXIMIZE));
  /*Restore a minimized window*/
  rb_define_const(Window, "SW_RESTORE", LONG2NUM(SW_RESTORE));
  /*Uses the default SW_ value of the application*/
  rb_define_const(Window, "SW_SHOWDEFAULT", LONG2NUM(SW_SHOWDEFAULT));
  /*Same as SW_MINIMIZE, but doesn't activate the window.*/
  rb_define_const(Window, "SW_SHOWMINNOACTIVE", LONG2NUM(SW_SHOWMINNOACTIVE));
  /*Same as SW_SHOW, but doesn't activate the window*/
  rb_define_const(Window, "SW_SHOWNA", LONG2NUM(SW_SHOWNA));
  /*Ordinary list view*/
  rb_define_const(ListView, "LIST", rb_str_new2("list"));
  /*Detailed view*/
  rb_define_const(ListView, "DETAILS", rb_str_new2("details"));
  /*View with small icons*/
  rb_define_const(ListView, "SMALL_ICONS", rb_str_new2("smallicons"));
  /*View with large icons*/
  rb_define_const(ListView, "LARGE_ICONS", rb_str_new2("largeicons"));
  
  //--
  //========================================================
  //Definieren von Instant-Variablen
  //========================================================
  //++
  
  /*Set to true if user input is blocked by #block_input= . */
  rb_ivar_set(AutoItX3, rb_intern("@input_blocked"), Qfalse);
  
  //--
  //========================================================
  //Definieren der Methoden
  //========================================================
  //++
  
  //--
  //misc.c
  //++
  
  rb_define_module_function(AutoItX3, "last_error", method_last_error, 0);
  rb_define_module_function(AutoItX3, "set_option", method_set_option, 2);
  rb_define_module_function(AutoItX3, "block_input=", method_block_input, 1);
  rb_define_module_function(AutoItX3, "input_blocked?", method_input_blocked, 0);
  rb_define_module_function(AutoItX3, "open_cd_tray", method_open_cd_tray, 1);
  rb_define_module_function(AutoItX3, "close_cd_tray", method_close_cd_tray, 1);
  rb_define_module_function(AutoItX3, "is_admin?", method_is_admin, 0);
  //rb_define_module_function(AutoItX3, "download_file", method_download_file, 2); //This method seems to have been removed. 
  rb_define_module_function(AutoItX3, "cliptext=", method_set_cliptext, 1);
  rb_define_module_function(AutoItX3, "cliptext", method_get_cliptext, 0);
  rb_define_module_function(AutoItX3, "tool_tip", method_tool_tip, -1);
  rb_define_module_function(AutoItX3, "msleep", method_msleep, 1);
  
  //--
  //filedir.c
  //++
  
  rb_define_module_function(AutoItX3, "add_drive_map", method_add_drive_map, -1);
  rb_define_module_function(AutoItX3, "delete_drive_map", method_delete_drive_map, 1);
  rb_define_module_function(AutoItX3, "get_drive_map", method_get_drive_map, 1);
  rb_define_module_function(AutoItX3, "delete_ini_entry", method_delete_ini_entry, 3);
  rb_define_module_function(AutoItX3, "read_ini_entry", method_read_ini_entry, 4);
  rb_define_module_function(AutoItX3, "write_ini_entry", method_write_ini_entry, 4);
  
  //--
  //graphic.c
  //++
  
  rb_define_module_function(AutoItX3, "pixel_checksum", method_pixel_checksum, -1);
  rb_define_module_function(AutoItX3, "get_pixel_color", method_get_pixel_color, 2);
  rb_define_module_function(AutoItX3, "search_for_pixel", method_search_for_pixel, -1);
  
  //--
  //keyboard.c
  //++
  
  rb_define_module_function(AutoItX3, "send_keys", method_send_keys, -1);
  
  //--
  //mouse.c
  //++
  
  rb_define_module_function(AutoItX3, "mouse_click", method_mouse_click, -1);
  rb_define_module_function(AutoItX3, "drag_mouse", method_drag_mouse, -1);
  rb_define_module_function(AutoItX3, "hold_mouse_down", method_hold_mouse_down, -1);
  rb_define_module_function(AutoItX3, "cursor_id", method_cursor_id, 0);
  rb_define_module_function(AutoItX3, "cursor_pos", method_cursor_pos, 0);
  rb_define_module_function(AutoItX3, "move_mouse", method_move_mouse, -1);
  rb_define_module_function(AutoItX3, "release_mouse", method_release_mouse, -1);
  rb_define_module_function(AutoItX3, "mouse_wheel", method_mouse_wheel, -1);
  
  //--
  //process.c
  //++
  
  rb_define_module_function(AutoItX3, "close_process", method_close_process, 1);
  rb_define_module_function(AutoItX3, "process_exists?", method_process_exists, 1);
  rb_define_module_function(AutoItX3, "set_process_priority", method_set_process_priority, 2);
  rb_define_module_function(AutoItX3, "wait_for_process", method_wait_for_process, -1);
  rb_define_module_function(AutoItX3, "wait_for_process_close", method_wait_for_process_close, -1);
  rb_define_module_function(AutoItX3, "run", method_run, -1);
  rb_define_module_function(AutoItX3, "run_as_set", method_run_as_set, -1);
  rb_define_module_function(AutoItX3, "run_and_wait", method_run_and_wait, -1);
  rb_define_module_function(AutoItX3, "shutdown", method_shutdown, -1);
  
  //--
  //window.c
  //++
  
  rb_define_method(Window, "initialize", method_init_window, -1);
  rb_define_method(Window, "inspect", method_inspect_window, 0);
  rb_define_method(Window, "to_s", method_to_s_window, 0);
  rb_define_method(Window, "to_i", method_to_i_window, 0);
  rb_define_method(Window, "activate", method_activate, 0);
  rb_define_method(Window, "active?", method_active, 0);
  rb_define_method(Window, "exists?", method_exists, 0);
  rb_define_method(Window, "class_list", method_class_list, 0);
  rb_define_method(Window, "client_size", method_client_size, 0);
  rb_define_method(Window, "handle", method_handle, 0);
  rb_define_method(Window, "rect", method_rect, 0);
  rb_define_method(Window, "pid", method_pid, 0);
  rb_define_method(Window, "visible?", method_visible, 0);
  rb_define_method(Window, "enabled?", method_enabled, 0);
  rb_define_method(Window, "minimized?", method_minimized, 0);
  rb_define_method(Window, "maximized?", method_maximized, 0);
  rb_define_method(Window, "state", method_state, 0);
  rb_define_method(Window, "text", method_text, 0);
  rb_define_method(Window, "title", method_title, 0);
  rb_define_method(Window, "kill", method_kill, 0);
  //WinList is not implemented in AutoItX3. 
  rb_define_method(Window, "select_menu_item", method_select_menu_item, -2);
  rb_define_method(Window, "move", method_move, -1);
  rb_define_method(Window, "set_on_top=", method_set_on_top, 1);
  rb_define_method(Window, "state=", method_set_state, 1);
  rb_define_method(Window, "title=", method_set_title, 1);
  rb_define_method(Window, "trans=", method_set_trans, 1);
  rb_define_method(Window, "wait", method_wait, -1);
  rb_define_method(Window, "wait_active", method_wait_active, -1);
  rb_define_method(Window, "wait_close", method_wait_close, -1);
  rb_define_method(Window, "wait_not_active", method_wait_not_active, -1);
  rb_define_method(Window, "focused_control", method_focused_control, 0);
  rb_define_method(Window, "statusbar_text", method_statusbar_text, -1);
  
  rb_define_singleton_method(Window, "exists?", method_exists_cl, -1);
  rb_define_singleton_method(Window, "caret_pos", method_caret_pos_cl, 0);
  rb_define_singleton_method(Window, "minimize_all", method_minimize_all_cl, 0);
  rb_define_singleton_method(Window, "undo_minimize_all", method_undo_minimize_all_cl, 0);
  rb_define_singleton_method(Window, "wait", method_wait_cl, -1);
  
  //--
  //control.c
  //++
  
  rb_define_method(Control, "initialize", method_init_control, 3);
  rb_define_method(Control, "click", method_click_ctl, -1);
  rb_define_method(Control, "disable", method_disable_ctl, 0);
  rb_define_method(Control, "enable", method_enable_ctl, 0);
  rb_define_method(Control, "focus", method_focus_ctl, 0);
  rb_define_method(Control, "handle", method_handle_ctl, 0);
  rb_define_method(Control, "rect", method_rect_ctl, 0);
  rb_define_method(Control, "text", method_text_ctl, 0);
  rb_define_method(Control, "move", method_move_ctl, -1);
  rb_define_method(Control, "send_keys", method_send_keys_ctl, -1);
  rb_define_method(Control, "text=", method_set_text_ctl, 1);
  rb_define_method(Control, "show", method_show_ctl, 0);
  rb_define_private_method(Control, "send_command_to_control", method_send_command_to_control, -1);
  rb_define_method(Control, "visible?", method_is_visible_ctl, 0);
  rb_define_method(Control, "enabled?", method_is_enabled_ctl, 0);
  
  rb_define_method(ListBox, "add", method_add_string_ib, 1);
  rb_define_method(ListBox, "<<", method_add_string_self_ib, 1);
  rb_define_method(ListBox, "delete", method_delete_string_ib, 1);
  rb_define_method(ListBox, "find", method_find_string_ib, 1);
  rb_define_method(ListBox, "current_selection=", method_set_current_selection_ib, 1);
  rb_define_method(ListBox, "select_string", method_select_string_ib, 1);
  rb_define_method(ListBox, "current_selection", method_current_selection_ib, 0);
  
  rb_define_method(ComboBox, "drop", method_drop_cb, 0);
  rb_define_method(ComboBox, "undrop", method_undrop_cb, 0);
  
  rb_define_method(Button, "checked?", method_is_checked_bt, 0);
  rb_define_method(Button, "check", method_check_bt, 0);
  rb_define_method(Button, "uncheck", method_uncheck_bt, 0);
  
  rb_define_method(Edit, "caret_pos", method_caret_pos_ed, 0);
  rb_define_method(Edit, "lines", method_lines_ed, 0);
  rb_define_method(Edit, "selected_text", method_selected_text_ed, 0);
  rb_define_method(Edit, "paste", method_paste_ed, 1);
  
  rb_define_method(TabBook, "current", method_current_tab, 0);
  rb_define_method(TabBook, "right", method_right_tab, 0);
  rb_define_method(TabBook, "left", method_left_tab, 0);
  
  rb_define_private_method(ListView, "send_command_to_list_view", method_send_command_to_list_view, -1);
  rb_define_method(ListView, "deselect", method_deselect_lv, -1);
  rb_define_method(ListView, "find", method_find_lv, -1);
  rb_define_method(ListView, "item_count", method_item_count_lv, 0);
  rb_define_method(ListView, "selected", method_selected_lv, 0);
  rb_define_method(ListView, "num_selected", method_num_selected_lv, 0);
  rb_define_method(ListView, "num_subitems", method_num_subitems_lv, 0);
  rb_define_method(ListView, "text_at", method_text_at_lv, -1);
  rb_define_method(ListView, "selected?", method_is_selected_lv, 1);
  rb_define_method(ListView, "select", method_select_lv, -1);
  rb_define_method(ListView, "select_all", method_select_all_lv, 0);
  rb_define_method(ListView, "clear_selection", method_clear_selection_lv, 0);
  rb_define_method(ListView, "invert_selection", method_invert_selection_lv, 0);
  rb_define_method(ListView, "change_view", method_change_view_lv, 1);
  
  rb_define_private_method(TreeView, "send_command_to_tree_view", method_send_command_to_tree_view, -1);
  rb_define_method(TreeView, "check", method_check_tv, 1);
  rb_define_method(TreeView, "collapse", method_collapse_tv, 1);
  rb_define_method(TreeView, "exists?", method_exists_tv, 1);
  rb_define_method(TreeView, "num_subitems", method_num_subitems_tv, 1);
  rb_define_method(TreeView, "selected", method_selected_tv, -1);
  rb_define_method(TreeView, "text_at", method_text_at_tv, 1);
  rb_define_method(TreeView, "checked?", method_is_checked_tv, 1);
  rb_define_method(TreeView, "select", method_select_tv, 1);
  rb_define_method(TreeView, "uncheck", method_uncheck_tv, 1);
  
  //--
  //========================================================
  //Aliases
  //========================================================
  //++
  
  rb_define_alias(au3single, "opt", "set_option");
  rb_define_alias(au3single, "write_clipboard", "cliptext=");
  rb_define_alias(au3single, "read_clipboard", "cliptext");
  rb_define_alias(au3single, "tooltip", "tool_tip");
  
  rb_define_alias(au3single, "pixel_color", "get_pixel_color");
  rb_define_alias(au3single, "pixel_search", "search_for_pixel");
  rb_define_alias(au3single, "search_pixel", "search_for_pixel");
  
  rb_define_alias(au3single, "click_mouse", "mouse_click");
  rb_define_alias(au3single, "mouse_down", "hold_mouse_down");
  rb_define_alias(au3single, "get_cursor_id", "cursor_id");
  rb_define_alias(au3single, "get_cursor_pos", "cursor_pos");
  rb_define_alias(au3single, "mouse_move", "move_mouse");
  rb_define_alias(au3single, "mouse_up", "release_mouse");
  
  rb_define_alias(au3single, "kill_process", "close_process");
  
  rb_define_alias(Window, "transparency=", "trans=");
  
  rb_define_alias(ComboBox, "close", "undrop");
  
  rb_define_alias(ListView, "size", "item_count");
  rb_define_alias(ListView, "length", "item_count");
  rb_define_alias(ListView, "[]", "text_at");
  rb_define_alias(ListView, "select_none", "clear_selection");
  
  rb_define_alias(TreeView, "[]", "text_at");
}
