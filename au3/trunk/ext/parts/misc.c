/*
*This file is part of au3. 
*Copyright © 2009 Marvin Gülker
*
*au3 is published under the same terms as Ruby. 
*See http://www.ruby-lang.org/en/LICENSE.txt
*
*=misc.c
*Miscellaneous methods that can't be categorized. 
*/

VALUE method_last_error(VALUE self)
{
  return INT2FIX(AU3_error());
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_set_option(VALUE self, VALUE option, VALUE value)
{
  return INT2NUM(AU3_AutoItSetOption(rstr_to_wstr(option), NUM2INT(value)));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_input_blocked(VALUE self)
{
  return rb_ivar_get(self, rb_intern("@input_blocked"));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_block_input(VALUE self, VALUE block)
{
  int b = 1;
  VALUE blocked = Qtrue;
  if (TYPE(block) == T_FALSE || TYPE(block) == T_NIL)
  {
    b = 0;
    blocked = Qfalse;
  }
  AU3_BlockInput(b);
  rb_ivar_set(self, rb_intern("@input_blocked"), blocked);
  return blocked;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_open_cd_tray(VALUE self, VALUE drive)
{
  return ((AU3_CDTray(rstr_to_wstr(drive), to_wchar_t("open")) == 1) ? Qtrue : Qfalse);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_close_cd_tray(VALUE self, VALUE drive)
{
  return ((AU3_CDTray(rstr_to_wstr(drive), to_wchar_t("closed")) == 1) ? Qtrue : Qfalse);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_is_admin(VALUE self)
{
  if (AU3_IsAdmin() == 0)
    return Qfalse;
  else
    return Qtrue;
}
//------------------------------------------------------------------------------------------------------------------------------------------
//This method seems to have been removed. 
/*VALUE method_download_file(VALUE self, VALUE url, VALUE target)
{
  if (AU3_URLDownloadToFile(to_wchar_t(StringValuePtr(url)), to_wchar_t(StringValuePtr(target))))
    return Qtrue;
  else
    return Qfalse;
}*/
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_set_cliptext(VALUE self, VALUE text)
{
  AU3_ClipPut(rstr_to_wstr(text));
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_get_cliptext(VALUE self)
{
  wchar_t cliptext[10000];
  AU3_ClipGet(cliptext, 10000);
  if (AU3_error() == 1)
    return rb_str_new2("");
  else
    return rb_str_new2(to_char(cliptext));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_tool_tip(int argc, VALUE argv[], VALUE self)
{
  int x = AU3_INTDEFAULT;
  int y = AU3_INTDEFAULT;
  
  if (argc == 3)
  {
    x = NUM2INT(argv[1]);
    y = NUM2INT(argv[2]);
  }
  else if (argc == 2)
    rb_raise(rb_eArgError, "Wrong number of arguments. You must specify a Y value.");
  else
    check_for_arg_error(argc, 1, 3);
  
  AU3_ToolTip(rstr_to_wstr(argv[0]), x, y);
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_msleep(VALUE self, VALUE msecs)
{
  AU3_Sleep(NUM2INT(msecs));
  return Qnil;
}
