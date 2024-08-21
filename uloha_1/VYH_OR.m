function [OR,STAN,zap]=VYH_OR(ST,SS,ZAP)
%%
% Funkce pro naleznutí souřadnic orientací a stanoviska
% Vstupní data:
%   ST-     číslo stanoviska
%   SS-     seznam souřadnic
%   ZAP-    zápisník měření
% Výstupní data:
%   OR-     matice orientací
%   STAN-   vektor stanoviska
%   zap-    matice podorbných bodů
%%
SS1=SS(:,1); ZAP1=ZAP(:,1); ST1=ST(:,1);    %redukce matic na dostačují počet dat
%% Vyhledání orientace 
q=1;
for n=1:length(SS1)
    for m=1:length(ZAP1)
        if SS1(n)==ZAP1(m)
            OR(q,:)=SS(m,:);
            zap(q,:)=ZAP(n,:);
            q=q+1;
        end
    end
end

%% Vyhledání Stanoviska
r=1;n=length(SS1);
while r==1
    if ST1==SS1(n)
        STAN=SS(n,:);
        r=0;
        n=n+1;
    end
    n=n-1;
end