clc; clear; format long g
%% načítání dat
fid=fopen('PB_SS.txt','r');
body=fscanf(fid,'%d %f %f %f',[4,inf])';
fclose(fid);
cl=body(:,1);
body=body(:,2:4);
%% Výpočet těžiště a odchylek od těžiště
T=[mean(body(:,1)),mean(body(:,2)),mean(body(:,3))];
x=body(:,1)-mean(body(:,1));
y=body(:,2)-mean(body(:,2));
z=body(:,3)-mean(body(:,3));
%% Výpočet koeficientů a konstanty
a=((x'*z)*(y'*y)-(x'*y)*(y'*z))/((x'*x)*(y'*y)-(x'*y)^2);
b=((x'*x)*(y'*z)-(x'*z)*(x'*y))/((x'*x)*(y'*y)-(x'*y)^2);
c=T(3)-a*T(1)-b*T(2);
%% Rovnice Oprav
v=a.*x+b.*y-z;
d=sqrt(v'*v)
kontrola=sum(v) %velmi blízké 0
%% Opravené výšky
z_op=body(:,3)+v;
%% Jendotkový vektor
u=[body(2,1)-body(1,1);body(2,2)-body(1,2);z_op(2,1)-z_op(1,1)];
v=[body(8,1)-body(1,1);body(8,2)-body(1,2);z_op(8,1)-z_op(1,1)];
w=cross(u,v);
W=w*(1/sqrt(w(1)^2+w(2)^2+w(3)^2));
D=-W(1)*body(1,1)-W(2)*body(1,2)-W(3)*z_op(1,1)
obc=[W;D];
fprintf('obecná rovnice roviny:   %6.4fx + %6.4fy + %6.4fz + %6.4f = 0',obc')
%% Seznam souřadnic
SS=[cl,body(:,1:2),z_op];
fid=fopen('SS_vyr.txt','w');
fprintf(fid,'%2d %15.3f %15.3f %9.3f\n',SS');
fclose(fid);



