function CAGASTE = FailDetector(x,y,giro,dificultad,pisito)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
global cont;
global xo;
global yo;
global ang_moneda;
global flag_ini;
global reset_caida;
global reset;
global timer_mov;


%*********************ROTACIONES DEL DISCO*********************************
a=cos(giro); 
b=sin(giro);
%*****************INVERSION DEL SENTIDO DE LA u****************************
ang_moneda=atan(-(-b+1.08*a*b*yo+1.08*a^2*xo)/(a+1.08*b^2*yo+1.08*a*b*xo)); 

%***************FINALES DE PISTA**************************************
x1d=0; x2d=0; x3d=0; x4d=0; x5d=0; x6d=0; x7d=0;
x1i=0; x2i=0; x3i=0; x4i=0; x5i=0; x6i=0; x7i=0;

switch dificultad
    case 1
        x1d=0*a-0.11429*b;
        x1i=-0.11*a-0.1092*b;
        
        x2d=0.20646*a-0.04555*b;
        x2i=0*a-0.06857*b;
        
        x3d=0*a-0.02286*b;
        x3i=-0.21142*a+0.00198*b;
        
        x4d=0.20639*a+0.04587*b;
        x4i=0*a+0.02286*b;
        
        x5d=0*a+0.06857*b;
        x5i=-0.19203*a+0.08846*b;
        
        x6d=0.16726*a+0.08757*b;
        x6i=0*a+0.11429*b;
        
        x7d=-0.02554*a+0.16035*b;
        x7i=-0.12744*a+0.16871*b;
        
    case 2
        x1d=0.06211*a-0.11223*b;
        x1i=-0.11*a-0.1092*b;
        
        x2d=0.20646*a-0.04555*b;
        x2i=-0.04758*a-0.06799*b;
        
        x3d=0.04969*a-0.02154*b;
        x3i=-0.21142*a+0.00198*b;
        
        x4d=0.20639*a+0.04587*b;
        x4i=-0.04847*a+0.02411*b;
        
        x5d=0.04406*a+0.06961*b;
        x5i=-0.19203*a+0.08846*b;
        
        x6d=0.16726*a+0.08757*b;
        x6i=-0.05409*a+0.11585*b;
        
        x7d=-0.02554*a+0.16035*b;
        x7i=-0.12744*a+0.16871*b;
    
    case 3
        x1d=0.12394*a-0.10605*b;
        x1i=-0.1*a-0.1092*b;
        
        x2d=0.20646*a-0.04555*b;
        x2i=-0.09503*a-0.06374*b;
        
        x3d=0.09924*a-0.01759*b;
        x3i=-0.21142*a+0.00198*b;
        
        x4d=0.20639*a+0.04587*b;
        x4i=-0.0968*a+0.02787*b;
        
        x5d=0.08803*a+0.07271*b;
        x5i=-0.19203*a+0.08846*b;
        
        x6d=0.16726*a+0.08757*b;
        x6i=-0.108*a+0.12053*b;
        
        x7d=-0.02554*a+0.16035*b;
        x7i=-0.12744*a+0.16871*b;
        
     case 4
        x1d=0.12394*a-0.10605*b;
        x1i=-0.1*a-0.1092*b;
        
        x2d=0.20646*a-0.04555*b;
        x2i=-0.14224*a-0.05771*b;
        
        x3d=0.14851*a-0.01102*b;
        x3i=-0.21142*a+0.00198*b;
        
        x4d=0.20639*a+0.04587*b;
        x4i=-0.14488*a+0.03412*b;
        
        x5d=0.1318*a+0.07789*b;
        x5i=-0.19203*a+0.08846*b;
        
        x6d=0.16726*a+0.08757*b;
        x6i=-0.108*a+0.12053*b;
        
        x7d=-0.02554*a+0.16035*b;
        x7i=-0.12744*a+0.16871*b;
        
        
end

CAGASTE = 0;
switch pisito
    case 1
        if x>=(x1d)
            
        else
            if ( (x<=x1i) )
%                 if giro>0
                if timer_mov>10

                end

            else
            end
        end
    case 2
        if x<=(x2i)
               
        else
            if x>(x2d)
                CAGASTE = 1;
            end
        end
    case 3
        if x>=(x3d)                
        else
            if x<(x3i)
                CAGASTE = 1;
            end
        end
    case 4
        if x<=(x4i)               
        else
            if x>(x4d)
                CAGASTE = 1;
            end
        end
     case 5
        if x>=(x5d)                
        else
            if x<(x5i)
                CAGASTE = 1;
            end
        end
     case 6
        if x<=(x6i)              
        else
            if x>(x6d)
                CAGASTE = 1;
            end
        end
     case 7
        if x>=(x7i) || x<(x7d) 
            CAGASTE = 0;
        end
end
end