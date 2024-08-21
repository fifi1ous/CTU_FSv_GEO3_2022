function [OP,orientace,op,roz]=orientacni_posun(zap,OR,ST)
%% Funkce na výpočet orientačního posunu
%   Vstupní data:
%       zap-        Matice zápisníku měření na orintace
%       OR-         Matice souřadnic orientací
%       ST-         Vektor souřadnic orientací
%   Výstupní data:
%       OP-         orientační posun v radiánech
%       op-         orientační posun v gonech d protokolu
%       orientace-  Matice všech směrníků
%       roz-        Matice rozdílů od orientačního posunu
%% Výpočet orientačních posunů
s=size(zap,1);
zap=sortrows(zap,1);
OR=sortrows(OR,1);
for n=1:s
    orientace(n,1)=atan2(OR(n,2)-ST(:,2),OR(n,3)-ST(:,3));
    if orientace(n,1)<0
        orientace(n,1)=orientace(n,1)+2*pi;
    end
    orientace(n,2)=orientace(n,1)-zap(n,6);
    if orientace(n,2)<0
        orientace(n,2)=orientace(n,2)+2*pi;
    end
end
orientace=[orientace,orientace(:,1:2)./pi*200];
op=mean(orientace(:,4));
OP=mean(orientace(:,2));
for n=1:s
    roz(n,1)=op-orientace(n,4);
end
roz=[OR(:,1),roz];
end