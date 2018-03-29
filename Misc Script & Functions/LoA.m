clear
clc

mean = input('what is the mean difference?\n');
SD = input('what is the standard deviation of the difference\n');

upperlimit = mean+(SD*1.96)
lowerlimit = mean-(SD*1.96)