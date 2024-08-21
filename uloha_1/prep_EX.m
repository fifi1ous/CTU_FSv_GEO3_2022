function [zmen]=prep_EX(body,SS)
%% Přepočet zápisníku excentrického stanoviska
%      Vstupní data:
%           body-   Matice měření-matice musí být převedena skriptem na
%           radiány
%           SS-     Seznam souřadnic
%      Výstupní data:
%           zmen-   matice zmeněných dat
%% úprava matic pro výpočty
body=sortrows(body,1);
ex=body(1,:);
body=body(2:end,:);
SS=sortrows(SS,1);
centr=SS(1,:);
SS=SS(3:end,:);
%% přepočet
for i=1:size(body,1)
    d(i,1)=sqrt((centr(1,2)-SS(i,2))^2+(centr(1,3)-SS(i,3))^2);
    E(i,1)=body(i,6)-ex(1,6);
    if E(i,1)<0
        E(i,1)=E(i,1)+2*pi;
    end
    del(i,1)=asin((ex(1,8)/d(i,1))*sin(E(i,1)));
end
zmen=[body(:,1),body(:,3),E./pi.*200,d,del./pi.*200,body(:,3)+del./pi.*200];
for i=1:size(zmen,1)
    if zmen(i,6)<0
        zmen(i,6)=zmen(i,5)+400;
    elseif zmen(i,6)>400
        zmen(i,6)=zmen(i,6)-400;
    end
end
end