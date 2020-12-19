%% TEC_ZONE_LOG

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
%  
%  Max              data array size
%  Dim              data dimension
%  Real_Max         real data array size
%  Real_Dim         real data dimension
%  Size             file size
%
%% method:(construction)
%%
%
%  obj = TEC_ZONE_LOG            1x1 TEC_ZONE_LOG obj array
%  obj = TEC_ZONE_LOG(obj)       obj is TEC_ZONE array, construct TEC_ZONE_LOG with same size
%  obj = TEC_ZONE_LOG(m)         mxm TEC_ZONE_LOG obj array
%  obj = TEC_ZONE_LOG([m,n])     mxn TEC_ZONE_LOG obj array
%
%% method:write_echo
%%
%
%  obj.write_echo()          write echo text to FileName.txt
%  obj.write_echo(fid)       write echo text to opened file
%
%% method:write_json
%%
%
%  obj.write_json               write echo text to FileName.json, with depth 0
%  obj.write_json(depth)        write echo text to FileName.json
%  obj.write_json(depth,fid)    write echo text to opened file
%% method:write_xml
%%
%
%  obj.write_json               write echo text to FileName.xml, with depth 0
%  obj.write_json(depth)        write echo text to FileName.xml
%  obj.write_json(depth,fid)    write echo text to opened file
%