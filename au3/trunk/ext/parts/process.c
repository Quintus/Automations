/*
*This file is part of au3. 
*Copyright © 2009 Marvin Gülker
*
*au3 is published under the same terms as Ruby. 
*See http://www.ruby-lang.org/en/LICENSE.txt
*
*=process.c
*Functions to manipulate Windows processes. 
*/

VALUE method_close_process(VALUE self, VALUE pid)
{
  LPCWSTR proc = rstr_to_wstr(rb_funcall(pid, rb_intern("to_s"), 0));
  AU3_ProcessClose(proc);
  return Qnil;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_process_exists(VALUE self, VALUE pid)
{
  long result;
  LPCWSTR proc = rstr_to_wstr(rb_funcall(pid, rb_intern("to_s"), 0));
  
  if (result = AU3_ProcessExists(proc))
    return INT2NUM(result);
  else
    return Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_set_process_priority(VALUE self, VALUE pid, VALUE priority)
{
  LPCWSTR proc = rstr_to_wstr(rb_funcall(pid, rb_intern("to_s"), 0));
  char err[100];
  
  AU3_ProcessSetPriority(proc, FIX2INT(priority));
  
  switch (AU3_error())
  {
    case 1:
    {
      sprintf(err, "Failed to set process priority of process %s!", to_char(proc));
      rb_raise(Au3Error, err);
    }
    case 2:
    {
      sprintf(err, "Unsupported priority %i!", FIX2INT(priority));
      rb_raise(Au3Error, err);
    }
  }
  
  return FIX2INT(priority);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_wait_for_process(int argc, VALUE argv[], VALUE self)
{
  int timeout = 0;
  LPCWSTR proc = rstr_to_wstr(rb_funcall(argv[0], rb_intern("to_s"), 0));
  check_for_arg_error(argc, 1, 2);
  if (argc == 2)
    timeout = NUM2INT(argv[1]);
  return AU3_ProcessWait(proc, timeout) ? Qtrue : Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_wait_for_process_close(int argc, VALUE argv[], VALUE self)
{
  int timeout = 0;
  LPCWSTR proc = rstr_to_wstr(rb_funcall(argv[0], rb_intern("to_s"), 0));
  check_for_arg_error(argc, 1, 2);
  if (argc == 2)
    timeout = NUM2INT(argv[1]);
  return AU3_ProcessWaitClose(proc, timeout) ? Qtrue : Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_run(int argc, VALUE argv[], VALUE self)
{
  LPCWSTR dir = to_wchar_t("");
  int flag = 1;
  long int pid;
  check_for_arg_error(argc, 1, 3);
  
  if (argc >= 2)
    dir = rstr_to_wstr(argv[1]);
  if (argc >= 3)
  {
    if (TYPE(argv[2]) == T_FALSE || TYPE(argv[2]) == T_NIL)
      flag = 0;
    else
      flag = 1;
  }
  pid = AU3_Run(rstr_to_wstr(argv[0]), dir, flag);
  
  //Gebe false bei Fehlschlag zurück
  if (AU3_error())
    return Qfalse;
  else
    return INT2NUM(pid);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_run_as_set(int argc, VALUE argv[], VALUE self)
{
  int flag = 1;
  
  check_for_arg_error(argc, 3, 4);
  
  if (argc == 4)
    flag = FIX2INT(argv[3]);
  
  if (AU3_RunAsSet(rstr_to_wstr(argv[0]), rstr_to_wstr(argv[1]), rstr_to_wstr(argv[2]), flag))
    return Qtrue;
  else
    rb_raise(rb_eNotImpError, "The method 'run_as_set' is not implemented on your system!");
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_run_and_wait(int argc, VALUE argv[], VALUE self)
{
  LPCWSTR dir = to_wchar_t("");
  int flag = 1;
  long int exitcode;
  check_for_arg_error(argc, 1, 3);
  
  if (argc >= 2)
    dir = rstr_to_wstr(argv[1]);
  if (argc >= 3)
  {
    if (TYPE(argv[2]) == T_FALSE || TYPE(argv[2]) == T_NIL)
      flag = 0;
    else
      flag = 1;
  }
  exitcode = AU3_RunWait(rstr_to_wstr(argv[0]), dir, flag);
  
  //Gebe false bei Fehlschlag zurück
  if (AU3_error())
    return Qfalse;
  else
    return INT2NUM(exitcode);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_shutdown(VALUE self, VALUE code)
{
  return (INT2NUM(AU3_Shutdown(FIX2INT(code))) == 0 ? Qfalse : Qtrue);
}
