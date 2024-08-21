function [zap]=RED_ZAP(body,OR)
%% funkce pro vytvoření zápisníku pro výpočet podorbných bodů
% Vstupní data:
%       body-matice celého zápisníku
%       OR-  matice zápisníku měřených hodnot na orientace
% Výstupní data:
%       zap- Matice zápisníku pro podrobné body
%% Redukce na relevantí data pro rozpoznání
body1=body(:,1);
OR1=OR(:,1);
%% Rouzpoznání pdorobných bodů
q=1;
for m=1:length(body1)
    if OR1~=body1(m)
        zap(q,:)=body(m,:);
        q=q+1;
    end
end
end