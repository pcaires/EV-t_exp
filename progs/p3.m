pkg load mapping
clear all
clc


D = dlmread('EV_2021.04C', ';', 1,0);
t_s = D(:,1);               % tempo da semana (s)
t_w = D(:,2);               % numero da semana

