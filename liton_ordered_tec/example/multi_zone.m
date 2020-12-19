%% Multi-Zone
% This is an example for using ordered_tec to create multi-zone file
%% clear
clear
close all
clc
%% use namespace
import liton_ordered_tec.*
%% prepare data

% zone 1
x1 = 0:0.01:5;
[x1,y1] = meshgrid(x1);
w1 = sin(x1).*cos(y1);
% zone 2
x2 = 4:0.01:9;
[x2,y2] = meshgrid(x2);
w2 = sin(x2).*cos(y2)+0.2;
%% pack data in TEC classes
tec_file = TEC_FILE;
tec_file.FileName = 'multi_zone';
tec_file.Variables = {'x','y','w'};
tec_file.Zones = TEC_ZONE([1,2]);
tec_file.Zones(1).Data = {x1,y1,w1};
tec_file.Zones(1).Skip = [3,3,1];
tec_file.Zones(2).Data = {x2,y2,w2};
tec_file.Zones(2).Skip = [2,2,1];
%% write data
tec_file = tec_file.write_plt();
