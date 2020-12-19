%% Multi-Zone
% This is an example for using ordered_tec to read data
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
%% pack data in TEC classes
tec_file = TEC_FILE;
tec_file.FileName = 'read_data';
tec_file.Variables = {'x','y','u','v'};
tec_file.Zones = TEC_ZONE;
tec_file.Zones.Data = {x,y,u,v};
tec_file.Zones.Skip = [2,2,1];
%% write data
tec_file = tec_file.write_plt();
tec_file.last_log.write_xml();
%% read data
logfile = TEC_FILE_LOG;
logfile = logfile.read_xml('read_data.xml');
data = logfile.read_to_cell('~','all','all');
disp(data)
data = logfile.read_to_cell('~','all',[1,2,4]);
disp(data)
data = logfile.read_to_struct('~','all',[1,2,4]);
disp(data)
