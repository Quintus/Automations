/*
*This file is part of au3. 
*Copyright © 2009 Marvin Gülker
*
*au3 is published under the same terms as Ruby. 
*See http://www.ruby-lang.org/en/LICENSE.txt
*
*=keyboard.c
*This file describes the bridge to the keyboard control 
*function of AutoItX. 
*/

VALUE method_send_keys(int argc, VALUE argv[], VALUE self)
{
  VALUE rstr;
  LPCWSTR flag = to_wchar_t("");
  
  check_for_arg_error(argc, 1, 2);
  
  if (argc == 2)
  {
    rstr = rb_funcall(argv[1], rb_intern("to_s"), 0);
    flag = rstr_to_wstr(rstr);
  }
  
  AU3_Send(rstr_to_wstr(argv[0]), *flag);
  
  return Qnil;
}
