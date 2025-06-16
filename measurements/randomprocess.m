a=arduino();
i=1;K=10;
t=15;
[degreesx,x]=measurment(t,K,a);

%% view

[rows1,cols1] = find(x>t);
ind =  min(rows1);
degreesx_new = degreesx(1:ind,:);
x_new = x(1:ind,:);
figure(1)
plot(x_new(:,2),degreesx_new(:,2));grid on;xlabel('time (sec)');ylabel('degrees (volt)');title('sensor read');
xlim([0,t]);
ylim([mean(degreesx(:,2))-0.4, mean(degreesx(:,2))+0.4]);
tempx=degreesx_new*100-273;
figure(2)
plot(x_new(:,2),tempx(:,2));grid on;xlabel('time (sec)');ylabel('degrees (celecius)');title('temprature');
xlim([0,t]);
ylim([mean(tempx(:,2))-2, mean(tempx(:,2))+2]);

%%
K=4;
T=[10,20,30,40];
l=1;
for i=1:length(T)
[degreesx,x]=measurment(T(i),K,a);
[rows1,cols1] = find(x>T(i));
ind =  min(rows1)
degreesx_new(1:ind,:,l) = degreesx(1:ind,:);
x_new(1:ind,:,l) = x(1:ind,:);
meanx=mean(degreesx_new(1:ind,:,l));
variance_Estimator(i)=var(meanx);
Estimation(i)=mean(meanx);
l=l+1;
end
temprature=100*Estimation-273.15;
plot(temprature)
ylim([mean(temprature)-4,mean(temprature)+4])
title('Temprature estimation wrt time interval');
xlabel('time interval');
ylabel('degrees');

temprature_variance=variance_Estimator*10^4;
plot(temprature_variance)
%ylim([mean(temprature_variance)-4,mean(temprature_variance)+4])
title('Temprature Variance estimation wrt time interval');
xlabel('time interval');
ylabel('degrees');

varxx = var(degreesx_new,0,2);
plot(varxx)

%%

N=200;
A=zeros(1,N);
Jmin=zeros(1,N);
A(1)=readVoltage(a,'A0');
Jmin(1)=0;
for h=2:(N)
    s=readVoltage(a,'A0');
A(h)=A(h-1)+(1/h)*(s-A(h-1));
Jmin(h)=Jmin(h-1)+((h-1)/(h))*(s-A(h-1))^2;
end

temprature=A*100-273.15;
plot(temprature);grid on; xlabel('number of points');ylabel('temprature');
title('temprature estimation using SLSE');

Jmin=Jmin*10^4;
n=0:(N-1);
plot(n,Jmin);grid on; xlabel('number of points');ylabel('the values of the cost function');
title('Cost Function');
%%%%%%
clear all; clc; close all;
t = [1,2,3,5,10,15,20,25,30];
for i=1:length(t)
    load(['degrees',num2str(t(i)),'.mat']);
    l(i)=size(T,1);
    m(i) = mean(mean(T));
    v(i) = var(mean(T));
end
noise_v=mean(v.*l);
x=m(end)+sqrt(noise_v)*rand(l(end),5);
meanx=mean(x);
error=mean((meanx-mean(T)).^2);


figure;
plot(t,v)
title('variance of estimation wrt to N');
xlabel('time (s)');
ylabel('variance');

figure;
plot(t,m)
title('Estimator wrt to N');
xlabel('time (s)');
ylabel('Estimator values');
ylim([mean(m)-4 mean(m)+4]);



