clc; clear; format long G
%% načtení dat
fid=fopen('zap.txt','r');
zap=fscanf(fid,'%f %f %f %f',[4,inf])';
fclose(fid);
fid=fopen('SS.txt','r');
SS=fscanf(fid,'%f %f %f %f',[4,inf])';
fclose(fid);
%% výpočet výšky
zap=[zap,zap(:,2:3)./200.*pi];
for n=1:size(zap,1)-1
    fi(n)=(0.00998/200*pi)*(zap(n+1,4)/1000)*sin(zap(n+1,6));
    dH(n)=zap(n+1,4)*cos(zap(n+1,6)-fi(n)/2);
    H(n)=SS(n+1,4)-dH(n)+1.7; % Výšky
end
%% redukce délek
m=0.9998713;
zap=[zap,zap(:,4).*sin(zap(:,6)).*m];
%% tranformace
B5001=[500,1000];
C=[5001;6001;6002];
for n=1:size(zap,1)-1
    Y(n)=B5001(1)+zap(n+1,7)*sin(zap(n+1,5));
    X(n)=B5001(2)+zap(n+1,7)*cos(zap(n+1,5));
end
B5001=[B5001;Y',X'];
M=[C,B5001];
%% měřítko
dm=sqrt((Y(1)-Y(2))^2+(X(1)-X(2))^2);               %délka místní
ds=sqrt((SS(2,2)-SS(3,2))^2+(SS(2,3)-SS(3,3))^2);   %délka S-JTSK
roz=ds-dm;                                          %rozdíl
q=ds/dm;                                            %měřítko
%% pootočení
w1=atan2(SS(3,2)-SS(2,2),SS(3,3)-SS(2,3));          %směrník s-jtsk
w2=atan2(M(3,2)-M(2,2),M(3,3)-M(2,3));              %jižník
if w1<0
    w1=w1+2*pi;
end
if w2<0
    w2=w2+2*pi;
end
w=w1-w2;                                            % Stočení os
%% posunutí
tx=SS(2,3)-q*(M(2,3)*cos(w)-M(2,2)*sin(w));         %posunutí počátku vůči X
ty=SS(2,2)-q*(M(2,3)*sin(w)+M(2,2)*cos(w));         % Posunutí počátku vůči X
for n=1:size(M,1)
    VYS(n,1)=M(n,1);
    VYS(n,2)=ty+q*(M(n,3)*sin(w)+M(n,2)*cos(w));
    VYS(n,3)=tx+q*(M(n,3)*cos(w)-M(n,2)*sin(w));        
end

VYS
