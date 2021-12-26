function ref = GenerarReferencia(y, riel)
%ref = GENERARREFERENCIA(y, riel)
%   Detailed explanation goes here

for i = 1:length(riel)
    if y > riel(i,2)
        ref = [riel(i,1) 0]';
        disp(i)
        return
    end
end
dips('FIN')
ref = [0 0]';


end

