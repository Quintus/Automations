#Encoding: UTF-8

module AutoItX3
  
  #This is the superclass for all controls. If you don't find 
  #a subclass of Control that matches your specific control, 
  #you can use the Control class itself (and if you call 
  #Window#focused_control, you *will* have to use it, 
  #since that method retuns a Control and not a subclass). 
  class Control
    
    @functions = {}
    
    class << self
      
      def functions
        @functions
      end
      
      def functions=(hsh)
        @functions = hsh
      end
      
      #Generates a control by using another control. 
      #This function is meant to be used with subclasses of Control, so you can do 
      #things like this: 
      #  #...
      #  ctrl = window.focused_control #This returns a Control instance
      #  #If you're sure it's an Edit, transform it into one: 
      #  ctrl = AutoItX3::Edit.from_control(ctrl)
      #  p ctrl.lines
      def from_control(ctrl)
        raise(ArgumentError, "Argument has to be a Control!") unless ctrl.kind_of? Control
        new(ctrl.instance_eval{@title}, ctrl.instance_eval{@text}, ctrl.instance_eval{@c_id})
      end
      
    end
    
    #Creates a new Control object. Pass in the title and text of 
    #the window holding the control (or "" if you don't want to specify one of them) 
    #and the ID of the control. Instead of the ID you may use the name of the 
    #control in combination width the occurence number of it, like "Edit1" and "Edit2". 
    def initialize(title, text, control_id)
      @title = title
      @text = text
      @c_id = control_id.to_s
    end
    
    #Clicks +self+ with the given mouse +button+ (<tt>"Primary"</tt> by default) 
    #+click+ times (1 by default) at the given position (middle by default). 
    def click(button = "Primary", clicks = 1, x = INTDEFAULT, y = INTDEFAULT)
      Control.functions[__method__] ||= AU3_Function.new("ControlClick", 'SSSSLLL', 'L')
      res = Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide, button.wide, clicks, x, y)
      if res == 0
        raise(Au3Error, "Could not click control '#{@c_id}' in '#{@title}' for some reason!")
      end
      nil
    end
    
    #Disables ("grays out") +self+. 
    def disable
      Control.functions[__method__] ||= AU3_Function.new("ControlDisable", 'SSS', 'L')
      res = Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide)
      if res == 0
        raise(Au3Error, "Could not disable control '#{@c_id}' in '#{@title}'!")
      end
      nil
    end
    
    #Enables +self+ (i.e. make it accept user actions). 
    def enable
      Control.functions[__method__] ||= AU3_Function.new("ControlEnable", 'SSS', 'L')
      res = Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide)
      if res == 0
        raise(Au3Error, "Could not enable control '#{@c_id}' in '#{@title}'!")
      end
      nil
    end
    
    #Gives the input focus to +self+. 
    def focus
      Control.functions[__method__] ||= AU3_Functino.new("ControlFocus", 'SSS', 'L')
      res = Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide)
      if res == 0
        raise(Au3Error, "Could not focus control '#{@c_id}' in '#{@title}!")
      end
      nil
    end
    
    #Returns the internal window handle of +self+. It can be used in 
    #advanced window mode or directly in Win32 API calls (but you have 
    #to call #to_i on the string than). 
    def handle
      Control.functions[__method__] ||= AU3_Function.new("ControlGetHandle", 'SSSPI')
      buffer = " " * BUFFER_SIZE
      buffer.wide!
      Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide, buffer, BUFFER_SIZE - 1)
      raise_unfound if AutoItX3.last_error == 1
      buffer.normal.strip
    end
    
    #Returns a 4-element array containing the control's position and size. 
    #Form is: <tt>[ x , y , width , height ]</tt>. 
    def rect
      Control.functions[:c_x] ||= AU3_Function.new("ControlGetPosX", 'SSS', 'L')
      Control.functions[:c_y] ||= AU3_Function.new("ControlGetPosY", 'SSS', 'L')
      Control.functions[:c_width] ||= AU3_Function.new("ControlGetPosWidth", 'SSS', 'L')
      Control.functions[:c_height] ||= AU3_Function.new("ControlGetPosHeight", 'SSS', 'L')
      
      params = [@title.wide, @text.wide, @c_id.wide]
      rectangle = [
        Control.functions[:c_x].call(*params), 
        Control.functions[:c_y].call(*params), 
        Control.functions[:c_width].call(*params), 
        Control.functions[:c_height].call(*params)
      ]
      raise_unfound if AutoItX3.last_error == 1
      rectangle
    end
    
    #Returns the +self+'s text. 
    def text
      Control.functions[__method__] ||= AU3_Function.new("ControlGetText", 'SSSPI')
      buffer = " " * BUFFER_SIZE
      buffer.wide!
      Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide, buffer, BUFFER_SIZE - 1)
      raise_unfound if AutoItX3.last_error == 1
      buffer.normal.strip
    end
    
    #Hides +self+. 
    def hide
      Control.functions[__method__] ||= AU3_Function.new("ControlHide", 'SSS', 'L')
      res = Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide)
      raise_unfound if res == 0
      nil
    end
    
    #Moves a control and optionally resizes it. 
    def move(x, y, width = -1, height = -1)
      Control.functions[__method__] ||= AU3_Function.new("ControlMove", 'SSSLLLL', 'L')
      res = Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide, x, y, width, height)
      raise_unfound if res == 0
      nil
    end
    
    #Simulates user input to a control. This works normally even on 
    #hidden and inactive windows. Please note that this method cannot 
    #send every keystroke AutoItX3.send_keys can, notably [ALT] combinations. 
    def send_keys(str, flag = 0)
      Control.functions[__method__] ||= AU3_Function.new("ControlSend", 'SSSSI', 'L')
      res = Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide, str.wide, flag)
      raise_unfound if res == 0
      nil
    end
    
    #Sets the text of a control directly. 
    def text=(text)
      Control.functions[__method__] ||= AU3_Function.new("ControlSetText", 'SSSS', 'L')
      res = Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide, text.wide)
      raise_unfound if res == 0
      text
    end
    
    #Shows a hidden control. 
    def show
      Control.functions[__method__] ||= AU3_Function.new("ControlShow", 'SSS', 'L')
      res = Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide)
      raise_unfound if res == 0
      nil
    end
    
    #Sends a command to a control. You won't need to use this method, since all commands 
    #are wrapped into methods. It's only used internally. 
    def send_command_to_control(command, arg = "")
      Control.functions[__method__] ||= AU3_Function.new("ControlCommand", 'SSSSSPI')
      buffer = " " * BUFFER_SIZE
      buffer.wide!
      Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide, command.wide, arg.to_s.wide, buffer, BUFFER_SIZE - 1)
      raise_unfound if AutoItX3.last_error == 1
      buffer.normal.strip
    end
    
    #Returns wheather or not a control is visible. 
    def visible?
      send_command_to_control("IsVisible") == 1
    end
    
    #Returns true if a control can interact with the user (i.e. it's not "grayed out"). 
    def enabled?
      send_command_to_control("IsEnabled") == 1
    end
    
    private
    
    def raise_unfound
      raise(Au3Error, "The control '#{@c_id}' was not found in the window '#{@title}' (or the window was not found)!", caller)
    end
    
  end
  
  #List boxes are controls in which you can select one 
  #or multiple items by clicking on it. ListBox is also 
  #the superclass of ComboBox. 
  class ListBox < Control
    
    #call-seq: 
    #  AutoItX3::ListBox#add( item ) ==> item
    #  AutoItX3::ListBox#<< item ==> self
    #
    #Adds an entry to an existing combo or list box. 
    #If you use the << form, you can do a chain call like: 
    #  ctrl << "a" << "b" << "c"
    def add_item(string)
      send_command_to_control("AddString", string)
      string
    end
    
    def <<(string) # :nodoc:
      add_item(string)
      self
    end
    
    #Delete item +no+. 
    def delete(item_number)
      send_command_to_control("DelString", item.to_s).to_i
    end
    
    #Finds the item number of +item+ in +self+. 
    def find(item)
      send_command_to_control("FindString", item).to_i
    end
    
    #Sets the current selection of a combo box to item +num+. 
    #The index is zero-based. Raises an Au3Error if +num+ is out 
    #of range. 
    def current_selection=(num)
      send_command_to_control("SetCurrentSelection", num.to_i)
      num
    end
    
    #Sets +self+'s selection to the first occurence of +str+. 
    #Raises an Au3Error if +str+ cannot be found. 
    def select_string(str)
      send_command_to_control("SelectString", str)
      string
    end
    
    #Returns the currently selected string. 
    def current_selection
      send_command_to_control("GetCurrentSelection")
    end
    
  end
  
  #A combo box is a control on which you click 
  #and then select a single item from the droped 
  #list box. 
  class ComboBox < ListBox
    
    #Drops down a combo box. 
    def drop
      send_command_to_control("ShowDropDown")
    end
    
    #call-seq: 
    #  undrop
    #  close
    #
    #Undrops or closes a combo box. 
    def undrop
      send_command_to_control("HideDropDown")
    end
    alias close undrop
    
  end
  
  #A button is a control on which you can click and than something happens. 
  #Even if that's quite correct, that isn't all: check and radio boxes 
  #are handled by Windows as buttons, so they fall into the scope of this class. 
  class Button < Control
    
    #Returns wheather +self+ is checked or not. 
    #Only useful for radio and check buttons. 
    def checked?
      send_command_to_control("IsChecked") == 1
    end
    
    #Checks +self+ if it's a radio or check button. 
    def check
      send_command_to_control("Check")
    end
    
    #Unchecks +self+ if it's a radio or check button. 
    def uncheck
      send_command_to_control("UnCheck")
    end
    
  end
  
  #An edit control is a single- or multiline input control in which you can 
  #type text. For example, notepad consists mainly of a big edit control. 
  class Edit < Control
    
    #Returns the current caret position in a 2-element array 
    #of form <tt>[line, column]</tt>. 
    def caret_pos
      x = send_command_to_control("GetCurrentLine").to_i
      y = send_command_to_control("GetCurrentCol").to_i
      [x, y]
    end
    
    #Returns the number of lines in +self+. 
    def lines
      send_command_to_control("GetLineCount").to_i
    end
    
    #Returns the currently selected text. 
    def selected_text
      send_command_to_control("GetSelected")
    end
    
    #"Pastes" +str+ at +self+'s current caret position. 
    def paste(str)
      send_command_to_control("EditPaste", str)
    end
    
  end
  
  #A tab book or tab bar is a control that shows up most often 
  #at the top of a window and lets you choice between different 
  #contents within the same window.  
  class TabBook < Control
    
    #Returns the currently shown tab. 
    def current
      send_command_to_control("CurrentTab").to_i
    end
    
    #Shows the tab right to the current one and returns the number 
    #of the now shown tab. 
    def right
      send_command_to_control("TabRight")
      current
    end
    
    #Shows the tab left to the current one and returns the number 
    #of the now shown tab. 
    def left
      send_command_to_control("TabLeft")
      current
    end
    
  end
  
  #A list view is a list which can contain many different 
  #columns of data. 
  class ListView < Control
    
    #Ordinary list view
    LIST = "list"
    #Detailed view
    DETAILS = "details"
    #View with small icons
    SMALL_ICONS = "smallicons"
    #View with large icons
    LARGE_ICONS = "largeicons"
    
    #Sends +cmd+ to +self+. This method is only used internally. 
    def send_command_to_list_view(command, arg1 = "", arg2 = "")
      Control.functions[__method__] ||= AU3_Function.new("ControlListView", 'SSSSSSPI')
      buffer = " " * BUFFER_SIZE
      buffer.wide!
      Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide, command.wide, arg1.to_s.wide, arg2.to_s.wide, buffer, BUFFER_SIZE - 1)
      raise(Au3Error, "Unknown error occured when sending '#{command}' to '#{@c_id}' in '#{@title}'! Maybe an invalid window?") if AutoItX3.last_error == 1
      buffer.normal.strip
    end
    
    #Deselects the given item(s). 
    def deselect(from, to = "")
      send_command_to_list_view("DeSelect", from, to)
    end
    
    #Searches for +string+ and +sub_item+ in +self+ and returns the index 
    #of the found list item or false if it isn't found. 
    def find(string, sub_item = "")
      res = send_command_to_list_view("FindItem", string, sub_item).to_i
      if res == -1
        false
      else
        res
      end
    end
    
    #call-seq: 
    #  item_count ==> anInteger
    #  size ==> anInteger
    #  length ==> anInteger
    #
    #Returns the number of items in +self+. 
    def item_count
      send_command_to_list_view("GetItemCount").to_i
    end
    alias size item_count
    alias length item_count
    
    #Returns the inices of the selected items in an array which is empty if 
    #none is selected. 
    def selected
      send_command_to_list_view("GetSelected", 1).split("|")
    end
    
    #Returns the number of selected items. 
    def num_selected
      send_command_to_list_view("GetSelectedCount").to_i
    end
    
    #Returns the number of subitems in +self+. 
    def num_subitems
      send_command_to_list_view("GetSubItemCount").to_i
    end
    
    #call-seq: 
    #  AutoItX3::ListView#text_at( item [, subitem ] ) ==> aString
    #  AutoItX3::ListView#[ item [, subitem ] ] ==> aString
    #
    #Returns the text at the given position. 
    def text_at(item, subitem = "")
      send_command_to_list_view("GetText", item, subitem)
    end
    alias [] text_at
    
    #Returns wheather or not +item+ is selected. 
    def selected?(item)
      send_command_to_list_view("IsSelected", item).to_i == 1
    end
    
    #Selects the given item(s). 
    def select(from, to = "")
      send_command_to_list_view("Select", from, to)
    end
    
    #Selects all items in +self+. 
    def select_all
      send_command_to_list_view("SelectAll")
    end
    
    #  AutoItX3::ListView#clear_selection ==> nil
    #  AutoItX3::ListView#select_none ==> nil
    #
    #Clears the selection. 
    def clear_selection
      send_command_to_list_view("SelectClear")
    end
    alias select_none clear_selection
    
    #Inverts the selection. 
    def invert_selection
      send_command_to_list_view("SelectInvert")
    end
    
    #Changes the view of +self+. Possible values of +view+ are 
    #all constants of the ListView class. 
    def change_view(view)
      send_command_to_list_view("ViewChange", view)
    end
    
  end
  
  #A TreeView is a control that shows a kind of expandable 
  #list, like the one displayed ont the left side in <tt>.chm</tt> files. 
  class TreeView < Control
    
    #Sends +cmd+ to +self+. This method is only used internally. 
    def send_command_to_tree_view(command, arg1 = "", arg2 = "")
      Control.functions[__method__] ||= AU3_Function.new("ControlTreeView", 'SSSSSSPI')
      buffer = " " * BUFFER_SIZE
      buffer.wide!
      Control.functions[__method__].call(@title.wide, @text.wide, @c_id.wide, command.wide, arg1.wide, arg2.wide, buffer, BUFFER_SIZE - 1)
      raise(Au3Error, "Unknown error occured when sending '#{command}' to '#{@c_id}' in '#{@title}'! Maybe an invalid window?") if AutoItX3.last_error == 1
      buffer.normal.strip
    end
    
    #Checks +item+ if it supports that operation. 
    def check(item)
      send_command_to_tree_view("Check", item)
    end
    
    #Collapses +item+ to hide its children. 
    def collapse(item)
      send_command_to_tree_view("Collapse", item)
    end
    
    #Return wheather or not +item+ exists. 
    def exists?(item)
      send_command_to_tree_view("Exists", item).to_i == 1
    end
    
    #Expands +item+ to show its children. 
    def expand(item)
      send_command_to_tree_view("Expand", item)
    end
    
    #Returns the number of children of +item+. 
    def num_subitems(item)
      send_command_to_tree_view("GetItemCount", item).to_i
    end
    
    #Returns the text reference or the index reference (if +use_index+ is true) of 
    #the selected item. 
    def selected(use_index = false)
      result = send_command_to_tree_view("GetSelected", use_index ? 1 : 0)
      return result.to_i if use_index
      result
    end
    
    #call-seq: 
    #  text_at( item ) ==> aString
    #  [ item ] ==> aString
    #
    #Returns the text of +item+. 
    def text_at(item)
      send_command_to_tree_view("GetText", item)
    end
    alias [] text_at
    
    #Returns wheather or not +item+ is checked. Raises an Au3Error 
    #if +item+ is not a checkbox. 
    def checked?(item)
      send_command_to_tree_view("IsChecked", item).to_i == 1
    end
    
    #Selects +item+. 
    def select(item)
      send_command_to_tree_view("Select", item)
    end
    
    #Unchecks +item+ if it suports that operation (i.e. it's a checkbox). 
    def uncheck(item)
      send_command_to_tree_view("Uncheck", item)
    end
    
  end
  
end