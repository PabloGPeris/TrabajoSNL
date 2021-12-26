function ref = GenerarReferencia(y, riel)
%ref = GENERARREFERENCIA(y, riel)
%   Detailed explanation goes here

for i = 1:length(riel)
    if y + 0.01 > riel(i,2)
        ref = riel(i,1);
        disp(i)
        return
    end
end
dips('FIN')
ref = 0;


end

