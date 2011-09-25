#This module contains the definitions for all the constants
#needed by Automations4win.
module Automations::Win::Wrappers::Constants

  #----------------------------------------
  #:section: General constants
  #----------------------------------------

  IDABORT    = 3
  IDCANCEL   = 2
  IDCONTINUE = 11
  IDIGNORE   = 5
  IDNO       = 7
  IDOK       = 1
  IDRETRY    = 4
  IDTRYAGAIN = 10
  IDYES      = 6

  #----------------------------------------
  #:section: FormatMessage() constants
  #----------------------------------------

  FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100
  FORMAT_MESSAGE_ARGUMENT_ARRAY  = 0x00002000
  FORMAT_MESSAGE_FROM_HMODULE    = 0x00000800
  FORMAT_MESSAGE_FROM_STRING     = 0x00000400
  FORMAT_MESSAGE_FROM_SYSTEM     = 0x00001000
  FORMAT_MESSAGE_IGNORE_INSERTS  = 0x00000200

  #----------------------------------------
  #:section: MessageBox() constants
  #----------------------------------------

  MB_ABORTRETRYIGNORE     = 0x00000002
  MB_CANCELTRYCONTINUE    = 0x00000006
  MB_HELP                 = 0x00004000
  MB_OK                   = 0x00000000
  MB_OKCANCEL             = 0x00000001
  MB_RETRYCANCEL          = 0x00000005
  MB_YESNO                = 0x00000004
  MB_YESNOCANCEL          = 0x00000003
  MB_ICONEXCLAMATION      = 0x00000030
  MB_ICONWARNING          = MB_ICONEXCLAMATION
  MB_ICONINFORMATION      = 0x00000040
  MB_ICONASTERISK         = MB_ICONINFORMATION
  MB_ICONQUESTION         = 0x00000020
  MB_ICONSTOP             = 0x00000010
  MB_ICONERROR            = MB_ICONSTOP
  MB_ICONHAND             = MB_ICONSTOP
  MB_DEFBUTTON1           = 0x00000000
  MB_DEFBUTTON2           = 0x00000100
  MB_DEFBUTTON3           = 0x00000200
  MB_DEFBUTTON4           = 0x00000300
  MB_APPLMODAL            = 0x00000000
  MB_SYSTEMMODAL          = 0x00001000
  MB_TASKMODAL            = 0x00002000
  MB_DEFAULT_DESKTOP_ONLY = 0x00020000
  MB_RIGHT                = 0x00080000
  MB_RTLREADING           = 0x00100000
  MB_SETFOREGROUND        = 0x00010000
  MB_TOPMOST              = 0x00040000
  MB_SERVICE_NOTIFICATION = 0x00200000

  #----------------------------------------
  #:section: SendInput() constants
  #----------------------------------------

  INPUT_MOUSE    = 0
  INPUT_KEYBOARD = 1
  INPUT_HARDWARE = 2

  MOUSEFACTOR = 65536
  
  XBUTTON1                    = 0x0001
  XBUTTON2                    = 0x0002
  MOUSEEVENTF_ABSOLUTE        = 0x8000
  MOUSEEVENTF_HWHEEL          = 0x01000
  MOUSEEVENTF_MOVE            = 0x0001
  MOUSEEVENTF_MOVE_NOCOALESCE = 0x2000
  MOUSEEVENTF_LEFTDOWN        = 0x0002
  MOUSEEVENTF_LEFTUP          = 0x0004
  MOUSEEVENTF_RIGHTDOWN       = 0x0008
  MOUSEEVENTF_RIGHTUP         = 0x0010
  MOUSEEVENTF_MIDDLEDOWN      = 0x0020
  MOUSEEVENTF_MIDDLEUP        = 0x0040
  MOUSEEVENTF_VIRTUALDESK     = 0x4000
  MOUSEEVENTF_WHEEL           = 0x0800
  MOUSEEVENTF_XDOWN           = 0x0080
  MOUSEEVENTF_XUP             = 0x0100

  #----------------------------------------
  #:section: GetSystemMetrics()
  #----------------------------------------

  SM_CXSCREEN          = 0
  SM_CYSCREEN          = 1
  SM_CXVSCROLL         = 2
  SM_CYHSCROLL         = 3
  SM_CYCAPTION         = 4
  SM_CXBORDER          = 5
  SM_CYBORDER          = 6
  SM_CXDLGFRAME        = 7
  SM_CYDLGFRAME        = 8
  SM_CYVTHUMB          = 9
  SM_CXHTHUMB          = 10
  SM_CXICON            = 11
  SM_CYICON            = 12
  SM_CXCURSOR          = 13
  SM_CYCURSOR          = 14
  SM_CYMENU            = 15
  SM_CXFULLSCREEN      = 16
  SM_CYFULLSCREEN      = 17
  SM_CYKANJIWINDOW     = 18
  SM_MOUSEPRESENT      = 19
  SM_CYVSCROLL         = 20
  SM_CXHSCROLL         = 21
  SM_DEBUG             = 22
  SM_SWAPBUTTON        = 23
  SM_RESERVED1         = 24
  SM_RESERVED2         = 25
  SM_RESERVED3         = 26
  SM_RESERVED4         = 27
  SM_CXMIN             = 28
  SM_CYMIN             = 29
  SM_CXSIZE            = 30
  SM_CYSIZE            = 31
  SM_CXFRAME           = 32
  SM_CYFRAME           = 33
  SM_CXMINTRACK        = 34
  SM_CYMINTRACK        = 35
  SM_CXDOUBLECLK       = 36
  SM_CYDOUBLECLK       = 37
  SM_CXICONSPACING     = 38
  SM_CYICONSPACING     = 39
  SM_MENUDROPALIGNMENT = 40
  SM_PENWINDOWS        = 41
  SM_DBCSENABLED       = 42
  SM_CMOUSEBUTTONS     = 43
  SM_SECURE            = 44
  SM_CXEDGE            = 45
  SM_CYEDGE            = 46
  SM_CXMINSPACING      = 47
  SM_CYMINSPACING      = 48
  SM_CXSMICON          = 49
  SM_CYSMICON          = 50
  SM_CYSMCAPTION       = 51
  SM_CXSMSIZE          = 52
  SM_CYSMSIZE          = 53
  SM_CXMENUSIZE        = 54
  SM_CYMENUSIZE        = 55
  SM_ARRANGE           = 56
  SM_CXMINIMIZED       = 57
  SM_CYMINIMIZED       = 58
  SM_CXMAXTRACK        = 59
  SM_CYMAXTRACK        = 60
  SM_CXMAXIMIZED       = 61
  SM_CYMAXIMIZED       = 62
  SM_NETWORK           = 63
  SM_CLEANBOOT         = 67
  SM_CXDRAG            = 68
  SM_CYDRAG            = 69
  SM_SHOWSOUNDS        = 70
  SM_CXMENUCHECK       = 71
  SM_CYMENUCHECK       = 72
  SM_SLOWMACHINE       = 73
  SM_MIDEASTENABLED    = 74
  SM_MOUSEWHEELPRESENT = 75
  SM_XVIRTUALSCREEN    = 76
  SM_YVIRTUALSCREEN    = 77
  SM_CXVIRTUALSCREEN   = 78
  SM_CYVIRTUALSCREEN   = 79
  SM_CMONITORS         = 80
  SM_SAMEDISPLAYFORMAT = 81

end
