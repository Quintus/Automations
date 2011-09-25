module Automations::Win::Wrappers::Structs

  #http://msdn.microsoft.com/en-us/library/dd162805%28v=VS.85%29.aspx
  #  typedef struct tagPOINT {
  #    LONG x;
  #    LONG y;
  #  } POINT, *PPOINT;
  class Point < FFI::Struct
    layout :x, :long,
           :y, :long
  end

  #http://msdn.microsoft.com/en-us/library/ms646273%28v=VS.85%29.aspx
  #  typedef struct tagMOUSEINPUT {
  #    LONG      dx;
  #    LONG      dy;
  #    DWORD     mouseData;
  #    DWORD     dwFlags;
  #    DWORD     time;
  #    ULONG_PTR dwExtraInfo;
  #  } MOUSEINPUT, *PMOUSEINPUT;
  class MouseInput < FFI::Struct
    layout :dx, :long,
           :dy, :long,
           :mouse_data, :int,
           :dw_flags, :int,
           :time, :int,
           :dw_extra_info, :pointer
  end

  #http://msdn.microsoft.com/en-us/library/ms646271%28v=VS.85%29.aspx
  #    typedef struct tagKEYBDINPUT {
  #    WORD      wVk;
  #    WORD      wScan;
  #    DWORD     dwFlags;
  #    DWORD     time;
  #    ULONG_PTR dwExtraInfo;
  #  } KEYBDINPUT, *PKEYBDINPUT;
  class KeybdInput < FFI::Struct
    layout :w_vk, :short,
           :w_scan, :short,
           :dw_flags, :int,
           :time, :int,
           :dw_extra_info, :pointer
  end

  #http://msdn.microsoft.com/en-us/library/ms646269%28v=VS.85%29.aspx
  #    typedef struct tagHARDWAREINPUT {
  #    DWORD uMsg;
  #    WORD  wParamL;
  #    WORD  wParamH;
  #  } HARDWAREINPUT, *PHARDWAREINPUT;
  class HardwareInput < FFI::Struct
    layout :u_msg, :int,
           :w_param_l, :short,
           :w_param_h, :short
  end

  #http://msdn.microsoft.com/en-us/library/ms646270%28v=VS.85%29.aspx
  #  typedef struct tagINPUT {
  #    DWORD type;
  #    union {
  #      MOUSEINPUT    mi;
  #      KEYBDINPUT    ki;
  #      HARDWAREINPUT hi;
  #    };
  #  } INPUT, *PINPUT;
  class Input < FFI::Struct
    
    class AnonymousUnion < FFI::Union
      layout :mi, MouseInput,
             :ki, KeybdInput,
             :hi, HardwareInput
    end
    layout :type, :int,
           :union, AnonymousUnion
  end
  
end
