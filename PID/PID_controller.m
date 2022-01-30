function u = PID_controller(kp,kd,ki,error,derror,ierror)
%PID_CONTROLLER Controlador PID simple.

u = kp*error + kd*derror + ki*ierror;

end

