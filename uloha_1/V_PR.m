function [OR,zap]=V_PR(SS,ZAP)
%%
% Funkce pro naleznutí připojovacích bodů
% Vstupní data:
%   SS-     seznam souřadnic
%   ZAP-    zápisník měření
% Výstupní data:
%   OR-     matice orientací
%   zap-    matice podorbných bodů
%%
SS1=SS(:,1); ZAP1=ZAP(:,1);   %redukce matic na dostačují počet dat
%% Vyhledání orientace 
q=1;
for n=1:length(SS1)
    for m=1:length(ZAP1)
        if SS1(n)==ZAP1(m)
            OR(q,:)=SS(n,:);
            zap(q,:)=ZAP(m,:);
            q=q+1;
        end
    end
end

