/*
*This file is part of au3. 
*Copyright © 2009 Marvin Gülker
*
*au3 is published under the same terms as Ruby. 
*See http://www.ruby-lang.org/en/LICENSE.txt
*
*=window.c
*This file contains the methods of class Window. 
*/

VALUE method_active(VALUE self);

/*
*Raises an Au3Error that says that the specified window couldn't be found. 
*/
void raise_unfound(VALUE title, VALUE text)
{
  rb_raise(Au3Error, "Unable to find a window with title '%s' and text '%s'!", StringValuePtr(title), StringValuePtr(text));
}

//--
//INSTANCE METHODS
//++

VALUE method_init_window(int argc, VALUE argv[], VALUE self)
{
  VALUE text = rb_str_new2("");
  check_for_arg_error(argc, 1, 2);
  
  if (argc == 2)
    text = argv[1];
  
  rb_ivar_set(self, rb_intern("@title"), argv[0]);
  rb_ivar_set(self, rb_intern("@text"), text);
  
  if ( TYPE(rb_funcall(Window, rb_intern("exists?"), 2, argv[0], text)) == T_FALSE)
    raise_unfound(argv[0], text);
  
  return self;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_inspect_window(VALUE self)
{
  char str[10000];
  VALUE title = rb_funcall(self, rb_intern("title"), 0);
  VALUE handle = rb_funcall(self, rb_intern("handle"), 0);
  sprintf( str, "<Window: %s (%s)>", StringValuePtr(title), StringValuePtr(handle) );
  return rb_str_new2(str);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_to_s_window(VALUE self)
{
  return rb_ivar_get(self, rb_intern("@title"));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_to_i_window(VALUE self)
{
  VALUE handle = rb_funcall(self, rb_intern("handle"), 0);
  return rb_funcall(handle, rb_intern("to_i"), 1, INT2FIX(16));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_activate(VALUE self)
{
  AU3_WinActivate( rstr_to_wstr(rb_ivar_get(self, rb_intern("@title"))), rstr_to_wstr(rb_ivar_get(self, rb_intern("@text"))) );
  return method_active(self);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_active(VALUE self)
{
  return ( ( AU3_WinActive(rstr_to_wstr(rb_ivar_get(self, rb_intern("@title"))), rstr_to_wstr(rb_ivar_get(self, rb_intern("@text")))) ) ? Qtrue : Qfalse );
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_close(VALUE self)
{
  AU3_WinClose( rstr_to_wstr(rb_ivar_get(self, rb_intern("@title"))), rstr_to_wstr(rb_ivar_get(self, rb_intern("@text"))) );
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_exists(VALUE self)
{
  return rb_funcall( Window, rb_intern("exists?"), rb_ivar_get(self, rb_intern("@title")), rb_ivar_get(self, rb_intern("@text")) );
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_class_list(VALUE self)
{
  wchar_t buffer[10000];
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  
  AU3_WinGetClassList(rstr_to_wstr(title), rstr_to_wstr(text), buffer, 10000);
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  return rb_funcall(wstr_to_rstr(buffer), rb_intern("split"), 1, rb_str_new2("\n"));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_client_size(VALUE self)
{
  long width;
  long height;
  
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  
  width = AU3_WinGetClientSizeWidth(rstr_to_wstr(title), rstr_to_wstr(text));
  height = AU3_WinGetClientSizeHeight(rstr_to_wstr(title), rstr_to_wstr(text));
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  return rb_ary_new3(2, LONG2NUM(width), LONG2NUM(height));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_handle(VALUE self)
{
  wchar_t buffer[10000];
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  
  AU3_WinGetHandle(rstr_to_wstr(title), rstr_to_wstr(text), buffer, 10000);
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  return wstr_to_rstr(buffer);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_rect(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE ary = rb_ary_new();
  
  rb_ary_push( ary, LONG2NUM(AU3_WinGetPosX(rstr_to_wstr(title), rstr_to_wstr(text))) );
  rb_ary_push( ary, LONG2NUM(AU3_WinGetPosY(rstr_to_wstr(title), rstr_to_wstr(text))) );
  rb_ary_push( ary, LONG2NUM(AU3_WinGetPosWidth(rstr_to_wstr(title), rstr_to_wstr(text))) );
  rb_ary_push( ary, LONG2NUM(AU3_WinGetPosHeight(rstr_to_wstr(title), rstr_to_wstr(text))) );
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  return ary;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_pid(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE res;
  wchar_t buffer[10000];
  
  AU3_WinGetProcess(rstr_to_wstr(title), rstr_to_wstr(text), buffer, 10000);
  
  if (wcslen(buffer) == 0)
    rb_raise(Au3Error, "Unknown error occured while retrieving process ID. Does the window exist?");
  
  res = wstr_to_rstr(buffer);
  return rb_funcall(res, rb_intern("to_i"), 0);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_visible(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  long state = AU3_WinGetState(rstr_to_wstr(title), rstr_to_wstr(text));
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  return ((state & 2) == 2) ? Qtrue : Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_enabled(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  long state = AU3_WinGetState(rstr_to_wstr(title), rstr_to_wstr(text));
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  return ((state & 4) == 4) ? Qtrue : Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_minimized(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  long state = AU3_WinGetState(rstr_to_wstr(title), rstr_to_wstr(text));
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  return ((state & 16) == 16) ? Qtrue : Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_maximized(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  long state = AU3_WinGetState(rstr_to_wstr(title), rstr_to_wstr(text));
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  return ((state & 32) == 32) ? Qtrue : Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_state(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  long state = AU3_WinGetState(rstr_to_wstr(title), rstr_to_wstr(text));
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  return LONG2NUM(state);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_text(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  wchar_t buffer[65537]; //64 KB (I hope...)
  
  AU3_WinGetText(rstr_to_wstr(title), rstr_to_wstr(text), buffer, 65537);
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  return wstr_to_rstr(buffer);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_title(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  wchar_t buffer[10000];
  
  AU3_WinGetTitle(rstr_to_wstr(title), rstr_to_wstr(text), buffer, 10000);
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  return wstr_to_rstr(buffer);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_kill(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  
  AU3_WinKill(rstr_to_wstr(title), rstr_to_wstr(text));
  
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
//TODO: This function simply doesn't work. No item is found, but why?
VALUE method_select_menu_item(VALUE self, VALUE args)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  int i = 8 - NUM2INT(rb_funcall(args, rb_intern("size"), 0)); 
  
  //Fill the remaining places until 8 with empty strings
  while (i > 0)
  {
    rb_ary_push(args, rb_str_new2(""));
    i--;
  }
  
  i = AU3_WinMenuSelectItem(rstr_to_wstr(title), rstr_to_wstr(text), 
    rstr_to_wstr(rb_ary_entry(args, 0)), rstr_to_wstr(rb_ary_entry(args, 1)), 
    rstr_to_wstr(rb_ary_entry(args, 2)), rstr_to_wstr(rb_ary_entry(args, 3)), 
    rstr_to_wstr(rb_ary_entry(args, 4)), rstr_to_wstr(rb_ary_entry(args, 5)), 
    rstr_to_wstr(rb_ary_entry(args, 6)), rstr_to_wstr(rb_ary_entry(args, 7)));
  
  if (!i)
    rb_raise(Au3Error, "The specified menu item could not be found.");
  
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_move(int argc, VALUE argv[], VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  long width = -1;
  long height = -1;
  
  check_for_arg_error(argc, 2, 4);
  
  if (argc >= 3)
    width = NUM2LONG(argv[2]);
  if (argc >= 4)
    height = NUM2LONG(argv[3]);
  
  AU3_WinMove(rstr_to_wstr(title), rstr_to_wstr(text), NUM2LONG(argv[0]), NUM2LONG(argv[1]), width, height);
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_set_on_top(VALUE self, VALUE val)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  int flag;
  
  if (RTEST(val))
    flag = 1;
  else
    flag = 0;
  
  AU3_WinSetOnTop(rstr_to_wstr(title), rstr_to_wstr(text), flag);
  
  return val;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_set_state(VALUE self, VALUE val)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  
  AU3_WinSetState(rstr_to_wstr(title), rstr_to_wstr(text), NUM2LONG(val));
  
  return val;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_set_title(VALUE self, VALUE new_title)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  
  AU3_WinSetTitle(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(new_title));
  
  return new_title;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_set_trans(VALUE self, VALUE trans)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  
  AU3_WinSetTrans(rstr_to_wstr(title), rstr_to_wstr(text), NUM2LONG(trans));
  
  if (AU3_error() == 1)
    rb_raise(rb_eNotImpError, "The method trans= is only implemented in Win2000 and newer!");
  
  return trans;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_wait(int argc, VALUE argv[], VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE timeout = INT2FIX(0);
  check_for_arg_error(argc, 0, 1);
  if (argc >= 1)
    timeout = argv[0];
  return rb_funcall(Window, rb_intern("wait"), title, text, timeout);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_wait_active(int argc, VALUE argv[], VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  long timeout = 0;
  
  check_for_arg_error(argc, 0, 1);
  
  if (argc >= 1)
    timeout = NUM2LONG(argv[1]);
  
  return AU3_WinWaitActive(rstr_to_wstr(title), rstr_to_wstr(text), timeout) ? Qtrue : Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_wait_close(int argc, VALUE argv[], VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  long timeout = 0;
  
  check_for_arg_error(argc, 0, 1);
  
  if (argc >= 1)
    timeout = NUM2LONG(argv[1]);
  
  return AU3_WinWaitClose(rstr_to_wstr(title), rstr_to_wstr(text), timeout) ? Qtrue : Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_wait_not_active(int argc, VALUE argv[], VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  long timeout = 0;
  
  check_for_arg_error(argc, 0, 1);
  
  if (argc >= 1)
    timeout = NUM2LONG(argv[1]);
  
  return AU3_WinWaitNotActive(rstr_to_wstr(title), rstr_to_wstr(text), timeout) ? Qtrue : Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_focused_control(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  wchar_t buffer[10000];
  char str[1000000];
  
  AU3_ControlGetFocus(rstr_to_wstr(title), rstr_to_wstr(text), buffer, 10000);
  
  if (AU3_error() == 1)
    raise_unfound(title, text);
  
  sprintf(str, "AutoItX3::Control.new('%s', '%s', '%s')", StringValuePtr(title), StringValuePtr(text), to_char(buffer));
  return rb_eval_string(str);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_statusbar_text(int argc, VALUE argv[], VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  wchar_t buffer[10000];
  int part = 1;
  check_for_arg_error(argc, 0, 1);
  
  if (argc == 1)
    part = NUM2INT(argv[0]);
  
  AU3_StatusbarGetText(rstr_to_wstr(title), rstr_to_wstr(text), part, buffer, 10000);
  
  if (AU3_error() == 1)
    rb_raise(Au3Error, "Couldn't read the statusbar's text at position %i! Are you sure the statusbar exists?", part);
  
  return wstr_to_rstr(buffer);
}

//--
//===================================================================
//CLASS METHODS
//===================================================================
//++

VALUE method_exists_cl(int argc, VALUE argv[], VALUE self)
{
  VALUE text = rb_str_new2("");
  check_for_arg_error(argc, 1, 2);
  
  if (argc == 2)
    text = argv[1];
  
  return ( ( AU3_WinExists(rstr_to_wstr(argv[0]), rstr_to_wstr(text)) ) ? Qtrue : Qfalse );
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_caret_pos_cl(VALUE self)
{
  long xpos;
  long ypos;
  
  xpos = AU3_WinGetCaretPosX();
  ypos = AU3_WinGetCaretPosY();
  
  if (AU3_error() == 1)
    rb_raise(Au3Error, "Unknown error occured while retrieving caret position!");
  
  return rb_ary_new3(2, LONG2NUM(xpos), LONG2NUM(ypos));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_minimize_all_cl(VALUE self)
{
  AU3_WinMinimizeAll();
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_undo_minimize_all_cl(VALUE self)
{
  AU3_WinMinimizeAllUndo();
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_wait_cl(int argc, VALUE argv[], VALUE self)
{
  VALUE text = rb_str_new2("");
  long timeout = 0;
  check_for_arg_error(argc, 1, 3);
  
  if (argc >= 2)
    text = argv[1];
  if (argc >= 3)
    timeout = NUM2LONG(argv[2]);
  
  return AU3_WinWait(rstr_to_wstr(argv[0]), rstr_to_wstr(text), timeout) ? Qtrue : Qfalse;
}
