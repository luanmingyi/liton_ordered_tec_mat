%% Data Type
% This is an example for using ordered_tec to create multi-type data file
%% clear
clear
close all
clc
%% use namespace
import liton_ordered_tec.*
%% prepare data
x = 0:0.1:2*pi;
y = 32*sin(x);
%% pack data in TEC classes
tec_file = TEC_FILE;
tec_file.FileName = 'data_type';
tec_file.Variables = {'x','single','double','int32','int16','int8'};
tec_file.Zones = TEC_ZONE;
tec_file.Zones.Data = {x,single(y),double(y),int32(y),int16(y),int8(y)};
tec_file = tec_file.write_plt();
tec_file.last_log.write_xml();
type data_type.xml
