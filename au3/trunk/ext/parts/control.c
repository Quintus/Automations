/*
*This file is part of au3. 
*Copyright © 2009 Marvin Gülker
*
*au3 is published under the same terms as Ruby. 
*See http://www.ruby-lang.org/en/LICENSE.txt
*
*=control.c
*All the functions to work with widgets, controls, or however childwindows
*are named. 
*/

void raise_unfound_ctl(VALUE title, VALUE c_id)
{
  rb_raise(Au3Error, "The control '%s' was not found in the window '%s' (or the window was not found)!", StringValuePtr(c_id), StringValuePtr(title));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_init_control(VALUE self, VALUE title, VALUE text, VALUE c_id)
{
  rb_ivar_set(self, rb_intern("@title"), title);
  rb_ivar_set(self, rb_intern("@text"), text);
  rb_ivar_set(self, rb_intern("@c_id"), rb_funcall(c_id, rb_intern("to_s"), 0)); //To allow integers to be used as IDs
  return self;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_click_ctl(int argc, VALUE argv[], VALUE self)
{
  LPCWSTR button = to_wchar_t("Primary");
  long clicks = 1;
  long x = AU3_INTDEFAULT;
  long y = AU3_INTDEFAULT;
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  
  check_for_arg_error(argc, 0, 4);
  
  if (argc >= 1)
    button = rstr_to_wstr(argv[0]);
  if (argc >= 2)
    clicks = NUM2LONG(argv[1]);
  if (argc >= 3)
    x = NUM2LONG(argv[2]);
  if (argc >= 4)
    y = NUM2LONG(argv[3]);
  
  if (AU3_ControlClick(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id), button, clicks, x, y))
    return Qtrue;
  else
    rb_raise(Au3Error, "Could not click control '%s' in '%s' for some reason!", StringValuePtr(c_id), StringValuePtr(title));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_disable_ctl(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  
  if ( AU3_ControlDisable(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id)) )
    return Qtrue;
  else
    rb_raise(Au3Error, "Could not disable control '%s' in '%s' for some reason!", StringValuePtr(c_id), StringValuePtr(title));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_enable_ctl(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  
  if ( AU3_ControlEnable(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id)) )
    return Qtrue;
  else
    rb_raise(Au3Error, "Could not enable control '%s' in '%s' for some reason!", StringValuePtr(c_id), StringValuePtr(title));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_focus_ctl(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  
  if ( AU3_ControlFocus(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id)) )
    return Qtrue;
  else
    rb_raise(Au3Error, "Could not focus control '%s' in '%s' for some reason!", StringValuePtr(c_id), StringValuePtr(title));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_handle_ctl(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  wchar_t buffer[10000];
  
  AU3_ControlGetHandle(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id), buffer, 10000);
  
  if (AU3_error() == 1)
    raise_unfound_ctl(title, c_id);
  return wstr_to_rstr(buffer);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_rect_ctl(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  long x;
  long y;
  long width;
  long height;
  
  x = AU3_ControlGetPosX(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id));
  y = AU3_ControlGetPosY(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id));
  width = AU3_ControlGetPosWidth(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id));
  height = AU3_ControlGetPosHeight(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id));
  
  if (AU3_error() == 1)
    raise_unfound_ctl(title, c_id);
  return rb_ary_new3(4, LONG2NUM(x), LONG2NUM(y), LONG2NUM(width), LONG2NUM(height));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_text_ctl(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  wchar_t buffer[10000];
  
  AU3_ControlGetText(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id), buffer, 10000);
  
  return wstr_to_rstr(buffer);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_hide_ctl(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  
  if (!AU3_ControlHide(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id)));
    raise_unfound_ctl(title, c_id);
  
  return Qtrue;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_move_ctl(int argc, VALUE argv[], VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  long width = -1;
  long height = -1;
  
  if (argc >= 3)
    width = NUM2LONG(argv[2]);
  if (argc >= 4)
    height = NUM2LONG(argv[3]);
  
  check_for_arg_error(argc, 2, 4);
  
  if ( !AU3_ControlMove(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id), NUM2LONG(argv[0]), NUM2LONG(argv[1]), width, height) )
    raise_unfound_ctl(title, c_id);
  
  return Qtrue;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_send_keys_ctl(int argc, VALUE argv[], VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  int flag = 0;
  
  check_for_arg_error(argc, 0, 1);
  
  if (argc == 1)
    flag = FIX2INT(argv[0]);
  
  if ( !AU3_ControlSend(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id), rstr_to_wstr(argv[0]), flag) )
    raise_unfound(title, c_id);
   return Qtrue;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_set_text_ctl(VALUE self, VALUE str)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  
  if ( !AU3_ControlSetText(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id), rstr_to_wstr(str)) )
    raise_unfound_ctl(title, c_id);
  return text;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_show_ctl(VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  
  if ( !AU3_ControlShow(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id)) )
    raise_unfound_ctl(title, c_id);
  return Qtrue;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_send_command_to_control(int argc, VALUE argv[], VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_funcall(rb_ivar_get(self, rb_intern("@c_id")), rb_intern("to_s"), 0);
  LPCWSTR option = to_wchar_t("");
  wchar_t buffer[10000];
  
  check_for_arg_error(argc, 1, 2);
  
  if (argc == 2)
    option = rstr_to_wstr(rb_funcall(argv[1], rb_intern("to_s"), 0));
  
  AU3_ControlCommand(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id), rstr_to_wstr(argv[0]), option, buffer, 10000);
  
  if (AU3_error() == 1)
    rb_raise(Au3Error, "Unknown error occured when sending '%s' to '%s' in '%s'! Maybe an invalid window?", StringValuePtr(argv[0]), StringValuePtr(c_id), StringValuePtr(title));
  
  return wstr_to_rstr(buffer);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_is_visible_ctl(VALUE self)
{
  VALUE result;
  result = rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("IsVisible"));
  result = rb_funcall(result, rb_intern("=="), 1, rb_str_new2("1"));
  return result;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_is_enabled_ctl(VALUE self)
{
  VALUE result;
  result = rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("IsEnabled"));
  result = rb_funcall(result, rb_intern("=="), 1, rb_str_new2("1"));
  return result;
}
/*==================================================
ListBox methods
===================================================*/
VALUE method_add_string_ib(VALUE self, VALUE string)
{
  rb_funcall(self, rb_intern("send_command_to_control"), 2, rb_str_new2("AddString"), string);
  return string;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_add_string_self_ib(VALUE self, VALUE string)
{
  method_add_string_ib(self, string);
  return self;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_delete_string_ib(VALUE self, VALUE item)
{
  rb_funcall(self, rb_intern("send_command_to_control"), 2, rb_str_new2("DelString"), rb_funcall(item, rb_intern("to_s"), 0));
  return item;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_find_string_ib(VALUE self, VALUE search)
{
  VALUE result; 
  result = rb_funcall(self, rb_intern("send_command_to_control"), 2, rb_str_new2("FindString"), search);
  return rb_funcall(result, rb_intern("to_i"), 0);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_set_current_selection_ib(VALUE self, VALUE item)
{
  rb_funcall(self, rb_intern("send_command_to_control"), 2, rb_str_new2("SetCurrentSelection"), rb_funcall(item, rb_intern("to_i"), 0));
  return item;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_select_string_ib(VALUE self, VALUE string)
{
  rb_funcall(self, rb_intern("send_command_to_control"), 2, rb_str_new2("SelectString"), string);
  return string;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_current_selection_ib(VALUE self)
{
  VALUE result;
  result = rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("GetCurrentSelection"));
  return result;
}
/*==================================================
ComboBox methods
===================================================*/
VALUE method_drop_cb(VALUE self)
{
  rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("ShowDropDown"));
  return Qtrue;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_undrop_cb(VALUE self)
{
  rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("HideDropDown"));
  return Qtrue;
}
/*==================================================
Button methods (check, radio and normal)
===================================================*/
VALUE method_is_checked_bt(VALUE self)
{
  VALUE result;
  result = rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("IsChecked"));
  result = rb_funcall(result, rb_intern("=="), 1, rb_str_new2("1"));
  return result;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_check_bt(VALUE self)
{
  rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("Check"));
  return Qtrue;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_uncheck_bt(VALUE self)
{
  rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("UnCheck"));
  return Qtrue;
}
/*==================================================
Edit methods
===================================================*/
VALUE method_caret_pos_ed(VALUE self)
{
  VALUE result = rb_ary_new();
  VALUE res;
  res = result, rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("GetCurrentLine"));
  rb_ary_push(result, rb_funcall(res, rb_intern("to_i"), 0));
  res = result, rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("GetCurrentCol"));
  rb_ary_push(result, rb_funcall(res, rb_intern("to_i"), 0));
  return result;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_lines_ed(VALUE self)
{
  VALUE result;
  result = rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("GetLineCount"));
  return rb_funcall(result, rb_intern("to_i"), 0);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_selected_text_ed(VALUE self)
{
  return rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("GetSelected"));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_paste_ed(VALUE self, VALUE string)
{
  rb_funcall(self, rb_intern("send_command_to_control"), 2, rb_str_new2("EditPaste"), string);
  return string;
}
/*==================================================
TabBook methods
===================================================*/
VALUE method_current_tab(VALUE self)
{
  VALUE result;
  result = rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("CurrentTab"));
  return rb_funcall(result, rb_intern("to_i"), 0);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_right_tab(VALUE self)
{
  rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("TabRight"));
  return method_current_tab(self);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_left_tab(VALUE self)
{
  rb_funcall(self, rb_intern("send_command_to_control"), 1, rb_str_new2("TabLeft"));
  return method_current_tab(self);
}
/*==================================================
ListView methods
===================================================*/
VALUE method_send_command_to_list_view(int argc, VALUE argv[], VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  LPCWSTR option1 = to_wchar_t("");
  LPCWSTR option2 = to_wchar_t("");
  wchar_t buffer[10000];
  
  check_for_arg_error(argc, 1, 3);
  
  if (argc >= 2)
    option1 = rstr_to_wstr(argv[1]);
  if (argc == 3)
    option2 = rstr_to_wstr(argv[2]);
  
  AU3_ControlListView(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id), rstr_to_wstr(argv[0]), option1, option2, buffer, 10000);
  
  if (AU3_error() == 1)
    rb_raise(Au3Error, "Unknown error occured when sending '%s' to '%s' in '%s'! Maybe an invalid window?", StringValuePtr(argv[0]), StringValuePtr(c_id), StringValuePtr(title));
  
  return wstr_to_rstr(buffer);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_deselect_lv(int argc, VALUE argv[], VALUE self)
{
  VALUE option2 = rb_str_new2("");
  
  check_for_arg_error(argc, 1, 2);
  
  if (argc == 2)
    option2 = rb_funcall(argv[1], rb_intern("to_s"), 0);
  
  rb_funcall(self, rb_intern("send_command_to_list_view"), 3, rb_str_new2("DeSelect"), rb_funcall(argv[0], rb_intern("to_s"), 0), option2);
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_find_lv(int argc, VALUE argv[], VALUE self)
{
  VALUE option2 = rb_str_new2("");
  long result;
  
  check_for_arg_error(argc, 1, 2);
  
  if (argc == 2)
    option2 = argv[1];
  
  result = NUM2LONG(rb_funcall(rb_funcall(self, rb_intern("send_command_to_list_view"), 3, rb_str_new2("FindItem"), argv[0], option2), rb_intern("to_i"), 0));
  
  if (result < 0)
    return Qfalse;
  else
    return result;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_item_count_lv(VALUE self)
{
  return rb_funcall(rb_funcall(self, rb_intern("send_command_to_list_view"), 1, rb_str_new2("GetItemCount")), rb_intern("to_i"), 0);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_selected_lv(VALUE self)
{
  VALUE result;
  int ary_len;
  int i;
  
  result = rb_funcall(self, rb_intern("send_command_to_list_view"), 2, rb_str_new2("GetSelected"), 1);
  result = rb_funcall(result, rb_intern("split"), 1, rb_str_new2("|"));
  ary_len = RARRAY_LEN(result);
  
  for (i=0; i < ary_len; i++)
    rb_funcall(result, rb_intern("[]="), 2, INT2NUM(i), rb_funcall(rb_funcall(result, rb_intern("[]"), 1, INT2NUM(i)), rb_intern("to_i"), 0));
  
  return result;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_num_selected_lv(VALUE self)
{
  return rb_funcall(rb_funcall(self, rb_intern("send_command_to_list_view"), 1, rb_str_new2("GetSelectedCount")), rb_intern("to_i"), 0);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_num_subitems_lv(VALUE self)
{
  return rb_funcall(rb_funcall(self, rb_intern("send_command_to_list_view"), 1, rb_str_new2("GetSubItemCount")), rb_intern("to_i"), 0);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_text_at_lv(int argc, VALUE argv[], VALUE self)
{
  VALUE subitem = rb_str_new2("");
  check_for_arg_error(argc, 1, 2);
  
  if (argc == 2)
    subitem = rb_funcall(argv[1], rb_intern("to_s"), 0);
  
  return rb_funcall(self, rb_intern("send_command_to_list_view"), 3, rb_str_new2("GetText"), rb_funcall(argv[0], rb_intern("to_s"), 0), subitem);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_is_selected_lv(VALUE self, VALUE item)
{
  int result;
  result = NUM2INT(rb_funcall(self, rb_intern("send_command_to_list_view"), 2, rb_str_new2("IsSelected"), rb_funcall(item, rb_intern("to_s"), 0)));
  
  if (result)
    return Qtrue;
  else
    return Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_select_lv(int argc, VALUE argv[], VALUE self)
{
  VALUE option2 = rb_str_new2("");
  
  check_for_arg_error(argc, 1, 2);
  
  if (argc == 2)
    option2 = rb_funcall(argv[1], rb_intern("to_s"), 0);
  
  rb_funcall(self, rb_intern("send_command_to_list_view"), 3, rb_str_new2("Select"), rb_funcall(argv[0], rb_intern("to_s"), 0), option2);
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_select_all_lv(VALUE self)
{
  rb_funcall(self, rb_intern("send_command_to_list_view"), 1, rb_str_new2("SelectAll"));
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_clear_selection_lv(VALUE self)
{
  rb_funcall(self, rb_intern("send_command_to_list_view"), 1, rb_str_new2("SelectClear"));
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_invert_selection_lv(VALUE self)
{
  rb_funcall(self, rb_intern("send_command_to_list_view"), 1, rb_str_new2("SelectInvert"));
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_change_view_lv(VALUE self, VALUE view)
{
  rb_funcall(self, rb_intern("send_command_to_list_view"), 2, rb_str_new2("ViewChange"), view);
  return view;
}
/*==================================================
TreeView methods
===================================================*/
VALUE method_send_command_to_tree_view(int argc, VALUE argv[], VALUE self)
{
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE text = rb_ivar_get(self, rb_intern("@text"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  LPCWSTR option1 = to_wchar_t("");
  LPCWSTR option2 = to_wchar_t("");
  wchar_t buffer[10000];
  
  check_for_arg_error(argc, 1, 3);
  
  if (argc >= 2)
    option1 = rstr_to_wstr(argv[1]);
  if (argc == 3)
    option2 = rstr_to_wstr(argv[2]);
  
  AU3_ControlTreeView(rstr_to_wstr(title), rstr_to_wstr(text), rstr_to_wstr(c_id), rstr_to_wstr(argv[0]), option1, option2, buffer, 10000);
  
  if (AU3_error() == 1)
    rb_raise(Au3Error, "Unknown error occured when sending '%s' to '%s' in '%s'! Maybe an invalid window?", StringValuePtr(argv[0]), StringValuePtr(c_id), StringValuePtr(title));
  
  return wstr_to_rstr(buffer);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_check_tv(VALUE self, VALUE item)
{
  rb_funcall(self, rb_intern("send_command_to_tree_view"), 2, rb_str_new2("Check"), rb_funcall(item, rb_intern("to_s"), 0));
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_collapse_tv(VALUE self, VALUE item)
{
  rb_funcall(self, rb_intern("send_command_to_tree_view"), 2, rb_str_new2("Collapse"), rb_funcall(item, rb_intern("to_s"), 0));
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_exists_tv(VALUE self, VALUE item)
{
  VALUE result;
  result = rb_funcall(self, rb_intern("send_command_to_tree_view"), 2, rb_str_new2("Exists"), rb_funcall(item, rb_intern("to_s"), 0));
  if (NUM2INT(result))
    return Qtrue;
  else
    return Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_expand_tv(VALUE self, VALUE item)
{
  rb_funcall(self, rb_intern("send_command_to_tree_view"), 2, rb_str_new2("Expand"), rb_funcall(item, rb_intern("to_s"), 0));
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_num_subitems_tv(VALUE self, VALUE item)
{
  return rb_funcall(rb_funcall(self, rb_intern("send_command_to_tree_view"), 2, rb_str_new2("GetItemCount"), rb_funcall(item, rb_intern("to_s"), 0)), rb_intern("to_i"), 0);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_selected_tv(int argc, VALUE argv[], VALUE self)
{
  VALUE use_index = Qfalse;
  check_for_arg_error(argc, 0, 1);
  
  if (argc == 1)
    use_index = argv[1];
  
  if (TYPE(use_index) != T_FALSE && TYPE(use_index) != T_NIL)
    return rb_funcall(rb_funcall(self, rb_intern("send_command_to_tree_view"), 2, rb_str_new2("GetSelected"), INT2FIX(1)), rb_intern("to_i"), 0);
  else
    return rb_funcall(self, rb_intern("send_command_to_tree_view"), 1, rb_str_new2("GetSelected"));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_text_at_tv(VALUE self, VALUE item)
{
  return rb_funcall(self, rb_intern("send_command_to_tree_view"), 2, rb_str_new2("GetText"), rb_funcall(item, rb_intern("to_s"), 0));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_is_checked_tv(VALUE self, VALUE item)
{
  int result;
  VALUE title = rb_ivar_get(self, rb_intern("@title"));
  VALUE c_id = rb_ivar_get(self, rb_intern("@c_id"));
  
  result = NUM2INT(rb_funcall(self, rb_intern("send_command_to_tree_view"), 2, rb_str_new2("IsChecked"), rb_funcall(item, rb_intern("to_s"), 0)));
  
  if (result == -1)
    rb_raise(Au3Error, "'%s' in '%s' is not a checkbox!", StringValuePtr(c_id), StringValuePtr(title));
  else if (result == 0)
    return Qfalse;
  return Qtrue;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_select_tv(VALUE self, VALUE item)
{
  rb_funcall(self, rb_intern("send_command_to_tree_view"), 2, rb_str_new2("Select"), rb_funcall(item, rb_intern("to_s"), 0));
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_uncheck_tv(VALUE self, VALUE item)
{
  rb_funcall(self, rb_intern("send_command_to_tree_view"), 2, rb_str_new2("Uncheck"), rb_funcall(item, rb_intern("to_s"), 0));
  return Qnil;
}
