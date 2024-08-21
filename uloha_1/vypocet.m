function [SS,BODY]=vypocet(OP,STAN,body,SS)
%% Výpočet souřadnic bodů
% Vstupní data:
%   OP-     orientační posun
%   STAN-   souřadnice stanoviska
%   body-   zápisník měření podrobných bodů
%   SS-     celkový seznma souřadnic
% Výstupní data:
%   SS-     seznam souřadnic s novými body
%   BODY-   nově vypočtené body
%% Výpočet nových bodů
for m=1:size(body,1)       
    OP1=OP+body(m,6);       %přepočet směrníku na daný bod
    if OP1>2*pi
        OP1=OP1-2*pi;   
    elseif OP1<0
        OP1=OP1+2*pi;
    end
    BODY(m,1)=body(m,1);
    BODY(m,2)=STAN(2)+sin(OP1)*body(m,8);   
    BODY(m,3)=STAN(3)+cos(OP1)*body(m,8);
end
SS=[SS;BODY];               %nový seznam souřadnic
end