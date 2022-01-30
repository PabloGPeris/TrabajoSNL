function ref = GenerarPiso(y, riel)
%ref = GENERARREFERENCIA(y, riel)
%   Detailed explanation goes here

for i = 1:length(riel)
    if y + 0.01 > riel(i,2)
        ref = i;
        return
    end
end
% disp('FIN')
ref = 0;


end

