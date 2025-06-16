clear all; clc; close all;
t = [1,2,3,5,10,15,20,25,30];
for i=1:length(t)
    load(['degrees',num2str(t(i)),'.mat']);
    m(i) = mean(mean(T));
    v(i) = var(mean(T));
end
figure;
plot(t,v)
title('variance of estimation wrt to N');
xlabel('time (s)');
ylabel('variance');
