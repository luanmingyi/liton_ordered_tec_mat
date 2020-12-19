%% Classes
% The tool box is written in OOP, and four classes are often used by user.

%% class list
% * TEC_FILE_BASE    base class of TEC_FILE and TEC_FILE_LOG, usually hidden to user
% * TEC_FILE    manage tec file, often used
% * TEC_FILE_LOG    manage log of tec file, often used
% * TEC_ZONE_BASE    base class of TEC_ZONE and TEC_ZONE_LOG, usually hidden to user
% * TEC_ZONE    manage tec zone, often used
% * TEC_ZONE_LOG    manage log of tec zone, often used

%% Inheritance relationship
%%
% 
%  TEC_FILE_BASE < TEC_FILE         manage tec file
%                < TEC_FILE_LOG     manage log of tec file
% 
%  TEC_ZONE_BASE < TEC_ZONE         manage tec zone
%                < TEC_ZONE_LOG     manage log of tec zone
% 
