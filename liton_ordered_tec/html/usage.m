%% Usage

%% Download and Configuration
% You only need to download the the folder |liton_ordered_tec| and add it to the search path of MATLAB. We will also distribute the package as a toolbox.

%% Coding
% The Tecplot file consists of zones and data are storage in zone. Zones describe different set of data in space or in time. All the numbers of data in different zones in one file are same. Auxiliary data is extra data attached to file or zone which can be seen and used in Tecplot.
%
% There are four classes usually used included in the |ORDERED_TEC| namespace. They are |TEC_FILE|, |TEC_ZONE| and correspondingly |TEC_FILE_LOG|, |TEC_ZONE_LOG| used to contain log.

%%
% To use the package, first you need some namespace declaration.
import liton_ordered_tec.*
%%
% Then you need to declare a |TEC_FILE| object and set its properties. The property |Variables| is a cell of string containing the variables' name which is required.
tec_file = TEC_FILE;
tec_file.Variables = {'x','y','w'};
%%
% You can also set some other properties optionally.
tec_file.FileName = 'Test';
tec_file.Title = 'Test';
tec_file.Auxiliary = {{'a1','1'},{'a2','2'}};
%%
% Then attach a |TEC_ZONE| object to the file and set its properties.
tec_file.Zones = TEC_ZONE;
[x,y]=meshgrid(1:100);
w=x*y;
tec_file.Zones.Data = {x,y,w};
%%
% You can also set some other properties optionally.
tec_file.Zones.ZoneName = 'zone_1';
tec_file.Zones.StrandId = 0;
tec_file.Zones.SolutionTime = 0.1;
tec_file.Zones.Begin = [0,1,0]; % begin of data from 2 in second dimension
tec_file.Zones.EEnd = [1,0,0]; % end of data offset 2 in first dimension
tec_file.Zones.Skip = [2,1,1]; % skip to write data by 2 in first dimension
tec_file.Zones.Auxiliary = {{'a1','1'},{'a2','2'}};
%%
% Before write data, you can set echo mode optionally. *These classes are value class, always remember to use the form of obj = obj.set_echo_mode(...)*
tec_file = tec_file.set_echo_mode('full','full');
%%
% And write data. *These classes are value class, always remember to use the form of obj = obj.write_plt(...)*
tec_file = tec_file.write_plt();
%%
% Now you can get log in |tec_file|'s property |last_log|. Also you can write the log in a xml file.
tec_file.last_log.write_xml();
type Test.xml
