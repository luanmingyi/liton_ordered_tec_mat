%% TEC_FILE

%% properties
%%
%
%  FilePath    '.'(default)
%  FileName    'untitled_file'(default)
%  Title       'untitled'(default)
%  Variables   e.g.: {'x','y','z',...}
%  FileType    0 = FULL(default), 1 = GRID, 2 = SOLUTION
%  Auxiliary   e.g.: {{'a1','1'},{'a2','2'},...}
%  Zones       TEC_ZONE obj array
%  Echo_Mode   1x7 logical array: [file_head, file_end, variable, section, size, time, usingtime] logical([1,1,1,0,0,1,0])(default)
%  last_log    TEC_FILE_LOG
%
%% method:(construction)
%%
%
%  obj = TEC_FILE            1x1 TEC_FILE obj array
%  obj = TEC_FILE(m)         mxm TEC_FILE obj array
%  obj = TEC_FILE([m,n])     mxn TEC_FILE obj array
%
%% method:set.Echo_Mode
%%
%
%  obj.Echo_Mode = mode    mode is 1x7 logical array
%  obj.Echo_Mode = mode    mode is char: 'brief':logical([1,1,1,0,0,1,0])  'full':all true  'simple': logical([1,0,0,0,0,1,0])  'none':all false  'leave':do nothing
%
%% method:set_echo_mode
%%
%
%  obj = obj.set_echo_mode                         do nothing
%  obj = obj.set_echo_mode(mode)                   set echo mode of file to mode
%  obj = obj.set_echo_mode(mode_file,mode_zone)    set echo mode of file to mode_file and all zones' to mode_zone
%% method:write_plt
%%
%
%  obj = obj.write_plt()    write plt file, and refresh last_log
