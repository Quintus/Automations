/*
*This file is part of au3. 
*Copyright © 2009 Marvin Gülker
*
*au3 is published under the same terms as Ruby. 
*See http://www.ruby-lang.org/en/LICENSE.txt
*
*=mouse.c
*Functions to control the mouse. 
*/

VALUE method_mouse_click(int argc, VALUE argv[], VALUE self)
{
  LPCWSTR button = to_wchar_t("Primary");
  int x = AU3_INTDEFAULT;
  int y = AU3_INTDEFAULT;
  int clicks = 1;
  int speed = 10;
  char err[100];
  
  check_for_arg_error(argc, 0, 5);
  
  if (argc >= 1)
    x = FIX2INT(argv[0]);
  if (argc >= 2)
    y = FIX2INT(argv[1]);
  if (argc >= 3)
    button = rstr_to_wstr(argv[2]);
  if (argc >= 4)
    clicks = FIX2INT(argv[3]);
  if (argc >= 5)
    speed = FIX2INT(argv[4]);
  
  AU3_MouseClick(button, x, y, clicks, speed);
  
  if (AU3_error() == 1)
  {
    sprintf(err, "Could not find mouse button '%s'!", to_char(button));
    rb_raise(Au3Error, err);
  }
  
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_drag_mouse(int argc, VALUE argv[], VALUE self)
{
  LPCWSTR button = to_wchar_t("Primary");
  int speed = 10;
  char err[100];
  
  check_for_arg_error(argc, 4, 6);
  
  if (argc >= 5)
    button = rstr_to_wstr(argv[4]);
  if (argc >= 6)
    speed = FIX2INT(argv[6]);
  
  AU3_MouseClickDrag(button, FIX2INT(argv[0]), FIX2INT(argv[1]), FIX2INT(argv[2]), FIX2INT(argv[3]), speed);
  
  if (AU3_error() == 1)
  {
    sprintf(err, "Could not find mouse button '%s'!", to_char(button));
    rb_raise(Au3Error, err);
  }
  
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_hold_mouse_down(int argc, VALUE argv[], VALUE self)
{
  LPCWSTR button = to_wchar_t("Primary");
  check_for_arg_error(argc, 0, 1);
  if (argc == 1)
    button = rstr_to_wstr(argv[0]);
  AU3_MouseDown(button);
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_cursor_id(VALUE self)
{
  return INT2FIX(AU3_MouseGetCursor());
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_cursor_pos(VALUE self)
{
  int x = AU3_MouseGetPosX();
  int y = AU3_MouseGetPosY();
  return rb_ary_new3(2, INT2NUM(x), INT2NUM(y));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_move_mouse(int argc, VALUE argv[], VALUE self)
{
  int speed = -1;
  check_for_arg_error(argc, 2, 3);
  if (argc == 3)
    speed = INT2FIX(argv[2]);
  AU3_MouseMove(NUM2INT(argv[0]), NUM2INT(argv[1]), speed);
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_release_mouse(int argc, VALUE argv[], VALUE self)
{
  LPCWSTR button = to_wchar_t("Primary");
  check_for_arg_error(argc, 0, 1);
  if (argc == 1)
    button = rstr_to_wstr(argv[0]);
  AU3_MouseUp(button);
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_mouse_wheel(int argc, VALUE argv[], VALUE self)
{
  int clicks = 5;
  char err[100];
  
  check_for_arg_error(argc, 1, 2);
  
  if (argc == 2)
    clicks = FIX2INT(argv[1]);
  
  AU3_MouseWheel(rstr_to_wstr(argv[0]), clicks);
  
  if (AU3_error() == 1)
  {
    sprintf(err, "Unrecognized mouse wheel direction '%s'!", StringValuePtr(argv[0]));
    rb_raise(Au3Error, err);
  }
  
  return Qnil;
}
