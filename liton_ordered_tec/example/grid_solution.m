%% Grid and Solution
% This is an example for using ordered_tec to create Grid and Solution
% file. You need to open the two files together.
%% clear
clear
close all
clc
%% use namespace
import liton_ordered_tec.*
%% prepare data
x = 0:0.05:2*pi;
[x,y] = meshgrid(x);
u = sin(x).*cos(y);
v = cos(x)+sin(y);
%% pack grid in TEC classes
tec_file_g = TEC_FILE;
tec_file_g.FileName = 'gs_g';
tec_file_g.FileType = 1;
tec_file_g.Variables = {'x','y'};
tec_file_g.Auxiliary = {{'a1','1'},{'a2','2'}};
tec_file_g.Zones = TEC_ZONE;
tec_file_g.Zones.Data = {x,y};
%% write grid
tec_file_g = tec_file_g.write_plt();
%% pack data in TEC classes
tec_file_s = TEC_FILE;
tec_file_s.FileName = 'gs_s';
tec_file_s.FileType = 2;
tec_file_s.Variables = {'u','v'};
tec_file_s.Zones = TEC_ZONE;
tec_file_s.Zones.Data = {u,v};
%% write data
tec_file_s = tec_file_s.write_plt();
