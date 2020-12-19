%%
clear
close all
clc
%%
addpath('../../liton_ordered_tec')
import liton_ordered_tec.*
%%
x = 0:0.05:2*pi;
[x,y] = meshgrid(x);
u = sin(x).*cos(y);
v = cos(x)+sin(y);
%%
tec_file = TEC_FILE;
tec_file.FileName = 'test_read';
tec_file.Variables = {'x','y','u','v'};
tec_file.Auxiliary = {{'a1','1'},{'a2','2'}};
tec_file.Zones = TEC_ZONE;
tec_file.Zones.Data = {x,y,u,v};
tec_file.Zones.Skip = [2,2,1];
%%
tec_file = tec_file.write_plt();
tec_file.last_log.write_echo();
tec_file.last_log.write_json();
tec_file.last_log.write_xml();
%%
logfile = TEC_FILE_LOG;
logfile = logfile.read_xml('test_read.xml');
data = logfile.read_to_cell('~','all','all');
disp(data)
data = logfile.read_to_cell('~','all',[1,2,4]);
disp(data)
data = logfile.read_to_struct('~','all',[1,2,4]);
disp(data)
