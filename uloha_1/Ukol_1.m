clc; clear; format long G
%% Polohový výpočet %%
%% načítání dat
fid=fopen('ss.txt','r');
SS=fscanf(fid,'%f %f %f',[3,inf])';
fclose(fid);
fid=fopen("mereni.txt",'r');
mer=fscanf(fid,'%f %f %f %f %f %f',[6,inf])';
fclose(fid);
fid=fopen("vysky.txt",'r');
VYSKY=fscanf(fid,'%d %f %f %f %f',[5,inf])';
fclose(fid);
fid=fopen("vysky2.txt",'r');
V=fscanf(fid,'%d %f',[2,inf])';
fclose(fid);
fid=fopen("mereni2.txt",'r');
VM=fscanf(fid,'%d %d %f %f %f',[5,inf])';
fclose(fid);
%% formátovaný výpis do protokolu
fid=fopen("protokol.txt",'w');
fprintf(fid,'Seznam souřadnic:    ČB        [Y]              [X]           \n');
fprintf(fid,'                    %4.f   %10.3f      %11.3f      \n',SS');
%% rozpoznani stanoviska,orientace podrobneho bodu
[st]=find(mer(:,1)~=0); d=length(st);       %rozpoznání stanoviska od měření
cislovani_vypoctu=1;
stan=mer(st(1),1:2);                        %rozdělení na proměné meření a stanovisko
body=mer(st(1)+1:end,2:end);
%% tisk zápisníku do protokolu
fprintf(fid,'\n\n[%d]',cislovani_vypoctu);
fprintf(fid,' Zápisník měření');
fprintf(fid,'                         stanovisko:     %4.f    %6.3f\n\n',stan);
fprintf(fid,'    bod     šikmá délka     vodorovný úhel      zenitový úhel      výška cíle\n');
fprintf(fid,'   %4.f  %10.3f         %8.4f            %8.4f            %6.3f\n',body');
%% převod pro výpočty
body=[body,body(:,3:4)./200.*pi];           %převod z radiánů na gony
body=[body,body(:,2).*sin(body(:,7))];      %převod na vodorovnou délku
%% výpočetní funkce
[OR,STAN,zap]=VYH_OR(stan,SS,body);         %naleznutí orientací
[OP,orientace,op,roz]=orientacni_posun(zap,OR,STAN);    %výpočet orientačního posunu
%% formátovaný výpis orientačního posunu
fprintf(fid,'\nOrientační posun:      %8.4f\n',op);
fprintf(fid,'Směr na orientaci      Rozdíl od orientačního posunu\n');
fprintf(fid,'   %6d                     %10.4f\n',roz');
%% Funkce pro zjistěnění měřených hodnot na podrobné body
[zap]=RED_ZAP(body,OR);
%% Výpočet souřadnice bodu 2 pomocí rajonu
[SS,BODY]=vypocet(OP,STAN,zap,SS);
fprintf(fid,'\nVypočtené souřadnice: Čb.     [Y]              [X]           \n');
fprintf(fid,'                    %4.f   %10.3f      %11.3f      \n',BODY');
%% Přepočet zápisníku na centrické
[zmen]=prep_EX(body,SS);
fprintf(fid,'\nVýpočet centračních změn směrů:\n');
fprintf(fid,'Směr na:   Osnova:   Osnova orientovaná na EC:  Délka(ze souřadnic): Centrační změny: Centrovaný směr:\n');
fprintf(fid,'%4.d      %8.4f           %8.4f               %10.3f        %9.4f          %8.4f\n',zmen');
%% Výpočet výšek %%
cislovani_vypoctu=cislovani_vypoctu+1;
%% Příprava dat
Mer2=0.999903997911;
[st]=find(stan(1)==SS(:,1));
BODYV=[SS(st,:),nan,Mer2];
for n=1:size(body,1)
    for m=1:size(VYSKY,1)
         if body(n,1)==VYSKY(m,1)
             mer2(m,:)=body(n,:);
         end
    end
end
PROM=[BODYV;VYSKY];
PROM=sortrows(PROM,1);VYSKY=sortrows(VYSKY,1);mer2=sortrows(mer2,1);
fprintf(fid,'\nVýpočet výšek [%da]:',cislovani_vypoctu);
fprintf(fid,'\nSeznam souřadnic bodů pro výpočet výšek:\n');
fprintf(fid,'  ČB          [Y]             [X]            [H]      měřítko:    \n');
fprintf(fid,'%4.d      %10.3f      %11.3f     %7.3f     %8.6f \n',PROM');
fi=0.009977/200*pi;
PROM=VYSKY(:,1);
k1=0;
k2=0.13;
R=6381*1000;
%% Výpočet výšky stanoviska a)
for n=1:size(VYSKY,1)
    s0(n,1)=(sqrt((VYSKY(n,2)-BODYV(1,2))^2+(VYSKY(n,3)-BODYV(1,3))^2))/((1/2)*(VYSKY(n,5)+BODYV(1,5)));
    a(n,1)=sqrt(s0(n,1)^2*(1+VYSKY(n,4)/R)+VYSKY(n,4)^2);
    alfa(n,1)=asin((VYSKY(n,4)/a(n,1))*cos(fi/2));
    ds1(n,1)=a(n,1)*((cos(alfa(n,1)-fi/2))/(sin(mer2(n,7)+k1*fi/2)));
    ds2(n,1)=a(n,1)*((cos(alfa(n,1)-fi/2))/(sin(mer2(n,7)+k2*fi/2)));
    dH1(n,1)=ds1(n,1)*((cos(mer2(n,7)-fi*(1-k1)/2))/(cos(fi/2)));
    dH2(n,1)=ds2(n,1)*((cos(mer2(n,7)-fi*(1-k2)/2))/(cos(fi/2)));
    H21(n,1)=VYSKY(n,4)-dH1(n,1)-stan(2)+cos(zap(1,7))*zap(1,2);
    H22(n,1)=VYSKY(n,4)-dH2(n,1)-stan(2)+cos(zap(1,7))*zap(1,2);
end
H11=mean(H21);
H12=mean(H22);
%% formátovaný výpis do protokolu
PROM0=[PROM,s0,a,alfa/pi*200];
PROM1=[PROM,ds1,dH1,H21];PROM2=[PROM,ds2,dH2,H22];
VYS1=[k1,mean(H21),H11;k2,mean(H22),H12]; VYS3=VYS1(1,3)-VYS1(2,3);
fprintf(fid,'\nMezivýsledky:\n');
fprintf(fid,'Stanovisko %d výška - %5.3f\n',stan');
fprintf(fid,'Č. koncového bodu:    Spojnice EK [m]:    Vzdálenost a [m]:      Úhel alfa [g]:\n');
fprintf(fid,'       %3d                 %8.3f             %8.3f          %8.4f\n',PROM0');
fprintf(fid,'\nMezivýsledky pro k = %4.2f:\n',k1);
fprintf(fid,'Č. koncového bodu:     Šikmá délka [m]:     Převýšení [m]:    Výška stanoviska [m]:\n');
fprintf(fid,'       %3d               %8.3f              %8.3f            %8.3f\n',PROM1');
fprintf(fid,'\nMezivýsledky pro k = %4.2f:\n',k2);
fprintf(fid,'Č. koncového bodu:     Šikmá délka [m]:     Převýšení [m]:    Výška stanoviska [m]:\n');
fprintf(fid,'       %3d               %8.3f              %8.3f            %8.3f\n',PROM2');
fprintf(fid,'\nVýšky bodů\n');
fprintf(fid,'  k:    Výška stanoviska [m]:     Výška bodu [m]:\n');
fprintf(fid,'%4.2f         %7.3f                %7.3f\n',VYS1');
fprintf(fid,'\n                                Rozdíl výsledků pro 2 koeficienty: %6.3f m\n',VYS3);
%% Výpočet výšky Stanoviska b)
fprintf(fid,'\nVýpočet výšek [%db]:\n',cislovani_vypoctu);
fprintf(fid,'Výšky bodů pro výpoč pomocí trigonometrické metody:\n');
fprintf(fid,'   ČB:     H[m]:\n');
fprintf(fid,'%5.f     %7.3f\n',V');
%% výpočet výšek
[st]=find(VM(:,1)~=0); d=length(st);   %za předpokladu, že máme stejně měření na stanoviscích
[st2]=find(VM(:,1)==0); q=length(st2)/d;
cislovani_vypoctu=1;
SMB=1/1000; SMC=2/1000;
for n=1:d
    %úprava zápisníku
    stan=VM(st(n),1:2);
    mv=VM(st(n)+1:st(n)+q,2:end);
    fprintf(fid,'\nZápisník měření:');
    fprintf(fid,'\n                         Stanovisko:     %4.f    %6.3f\n',stan);
    fprintf(fid,'  ČB:    Zenitový úhel:      Šikmá vzdálenost:    Výška cíle:\n');
    fprintf(fid,' %4d       %9.4f               %7.3f          %5.3f\n',mv');
    %výpočet výšky
    mv=[mv,mv(:,2)/200*pi];
    [pr,zp]=V_PR(V,mv);
    Hp=pr(2)+zp(4);
    [zp]=RED_ZAP(mv,pr);
    zp1=[mean(zp(:,5)),mean(zp(:,3)),mean(zp(:,4))];
    H(n,1)=pr(1);
    H(n,2)=Hp+zp1(2)*cos(zp1(1)-k1-fi/2)-zp1(3);
    %směrodatná odchylka
    VD=zp1(2)-zp(:,3); q1=length(VD);
    smd=sqrt((VD'*VD)/(q1*(q1-1)));
    VS=sortrows(zp(:,5)); VS=[VS(1);VS(end)]; VS=mean(VS)-VS; q1=length(VS);
    sms=sqrt((VS'*VS)/(q1*(q1-1)));
    H(n,3)=sqrt((smd^2)*(cos(zp1(1))^2)+(sms^2)*(zp1(2)^2*sin(zp1(1))^2)+SMB^2+SMC^2);
end
H1=mean(H(:,2));
HR=H(1,2)-H(2,2);
fprintf(fid,'\nVypočtené výšky bodu:\n');
fprintf(fid,'Z bodu č:  Výška bodu:  Směrodatná odchylka:\n');
fprintf(fid,'  %4.d        %7.3f          %6.4f\n',H');
if HR<=0.010
    fprintf(fid,'\nRozdíl <= 10, mezní rozdíl splněn| rozdíl v mm: %2.0f\n',HR'*1000);
else
    fprintf(fid,'\nRozdíl > 10, mezní rozdíl nesplněn| rozdíl v mm: %2.0d\n',HR'*1000);
end
fprintf(fid,'Výsledná výška bodu určena průměrem v m: %7.3f',H1');
fclose(fid);