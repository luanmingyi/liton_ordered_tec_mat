%%
clear
close all
clc
%%
addpath('../../liton_ordered_tec')
import liton_ordered_tec.*
%%
x = 0:0.01:5;
[x,y] = meshgrid(x);
w = sin(x).*cos(y);
%%
tec_file = TEC_FILE;
tec_file.Variables = {'x','y','w'};
tec_file.Zones = TEC_ZONE;
tec_file.Zones.Data = {x,y,w};
%%
tec_file = tec_file.write_plt();
