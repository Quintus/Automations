/*
*This file is part of au3. 
*Copyright © 2009 Marvin Gülker
*
*au3 is published under the same terms as Ruby. 
*See http://www.ruby-lang.org/en/LICENSE.txt
*
*=filedir.c
*Methods that deal with file and directory management. 
*/

VALUE method_add_drive_map(int argc, VALUE argv[], VALUE self)
{
  wchar_t username[1000];
  wchar_t password[1000];
  int flags = 0;
  wchar_t buffer[1000];
  char err[60];
  
  //Argumentanzahl prüfen
  check_for_arg_error(argc, 2, 5);
  
  //Optionale Argumente zuweisen
  if (argc >= 3)
    flags = NUM2INT(argv[2]);
  if (argc >= 4)
    wcscpy(username, rstr_to_wstr(argv[3]));
  if (argc >= 5)
    wcscpy(password, rstr_to_wstr(argv[4]));
  
  //AutoItX-Aufruf durchführen
  AU3_DriveMapAdd(rstr_to_wstr(argv[0]), rstr_to_wstr(argv[1]), flags, username, password, buffer, 1000);
  
  //Auf Fehler prüfen
  switch (AU3_error())
  {
    case 1:
    {
      rb_raise(Au3Error, "Unknown error occured while mapping network drive!");
      break;
    }
    case 2:
    {
      rb_raise(Au3Error, "Access denied!");
      break;
    }
    case 3:
    {
      sprintf(err, "Device '%s' is already assigned!", StringValuePtr(argv[0]));
      rb_raise(Au3Error, err);
      break;
    }
    case 4:
    {
      sprintf(err, "Invalid device name '%s'!", StringValuePtr(argv[0]));
      rb_raise(Au3Error, err);
      break;
    }
    case 5:
    {
      sprintf(err, "Invalid remote share '%s'!", StringValuePtr(argv[1]));
      rb_raise(Au3Error, err);
      break;
    }
    case 6:
    {
      rb_raise(Au3Error, "The password is incorrect!");
      break;
    }
  }
  
  //Return returned string
  return wstr_to_rstr(buffer);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_delete_drive_map(VALUE self, VALUE device)
{
  if (AU3_DriveMapDel(rstr_to_wstr(device)))
    return Qtrue;
  else
    return Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_get_drive_map(VALUE self, VALUE device)
{
  wchar_t buffer[1000];
  char err[100];
  AU3_DriveMapGet(rstr_to_wstr(device), buffer, 1000);
  
  if (AU3_error() == 1)
  {
    sprintf(err, "Failed to retrieve information about device '%s'!", StringValuePtr(device));
    rb_raise(Au3Error, err);
  }
  
  return wstr_to_rstr(buffer);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_delete_ini_entry(VALUE self, VALUE filename, VALUE section, VALUE key)
{
  if (AU3_IniDelete(rstr_to_wstr(filename), rstr_to_wstr(section), rstr_to_wstr(key)))
    return Qtrue;
  else
    return Qfalse;
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_read_ini_entry(VALUE self, VALUE filename, VALUE section, VALUE key, VALUE def)
{
  wchar_t buffer[10000];
  AU3_IniRead(rstr_to_wstr(filename), rstr_to_wstr(section), rstr_to_wstr(key), rstr_to_wstr(def), buffer, 10000);
  return wstr_to_rstr(buffer);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_write_ini_entry(VALUE self, VALUE filename, VALUE section, VALUE key, VALUE value)
{
  if (AU3_IniWrite(rstr_to_wstr(filename), rstr_to_wstr(section), rstr_to_wstr(key), rstr_to_wstr(value)))
    return value;
  else
    rb_raise(Au3Error, "Cannot open file for write access!");
  return Qfalse;
}
