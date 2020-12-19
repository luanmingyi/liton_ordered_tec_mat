%% TEC_ZONE

%% properties
%%
%
%  ZoneName         'untitled_zone'(default)
%  StrandId         -1(default)
%  SolutionTime     0(default)
%  Skip             [1,1,1](default)
%  Begin            [0,0,0](default)
%  EEnd             [0,0,0](default)
%  Auxiliary        e.g.: {{'a1','1'},{'a2','2'},...}
%  Data             e.g.: {x,y,z,...}
%  Echo_Mode        1x9 logical array: [zone_head, zone_end, variable, max_real, max_org, skip, begin & end, stdid & soltime, size] logical([1,0,0,1,0,0,0,0,0])(default)
%
%% method:(construction)
%%
%
%  obj = TEC_ZONE            1x1 TEC_ZONE obj array
%  obj = TEC_ZONE(m)         mxm TEC_ZONE obj array
%  obj = TEC_ZONE([m,n])     mxn TEC_ZONE obj array
%
%% method:set.Echo_Mode
%%
%
%  obj.Echo_Mode = mode    mode is 1x9 logical array
%  obj.Echo_Mode = mode    mode is char: 'brief':logical([1,0,0,1,0,0,0,0,0])  'full':all true  'simple': logical([1,0,0,0,0,0,0,0,0])  'none':all false  'leave':do nothing
%
