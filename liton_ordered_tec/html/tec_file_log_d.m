%% TEC_FILE_LOG

%% properties
%%
%
%  FilePath    '.'(default)
%  FileName    'untitled_file'(default)
%  Title       'untitled'(default)
%  Variables   e.g.: {'x','y','z',...}
%  FileType    0 = FULL(default), 1 = GRID, 2 = SOLUTION
%  Auxiliary   e.g.: {{'a1','1'},{'a2','2'},...}
%  
%  Time_Begin  time begin write
%  Time_End    time end write
%  UsingTime   using time
%  Size        file size
%
%% method:(construction)
%%
%
%  obj = TEC_FILE_LOG            1x1 TEC_FILE_LOG obj array
%  obj = TEC_FILE_LOG(obj)       obj is TEC_FILE array, construct TEC_FILE_LOG with same size
%  obj = TEC_FILE_LOG(m)         mxm TEC_FILE_LOG obj array
%  obj = TEC_FILE_LOG([m,n])     mxn TEC_FILE_LOG obj array
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
%% method:read_xml
%%
%
%  obj = obj.read_xml(file_root)     read xml, file_root is file name
%  obj = obj.read_xml(file_root)     read xml, file_root is xml Element, see help of xmlread
%
%% method:read_to_cell
%%
%
%  data = obj.read_to_cell(filepath,zone,var)     read data by the infomation in the TEC_FILE_LOG
%                                                 filepath: '~' or new file path
%                                                 zone: 'all' or [1,3,...]
%                                                 var: 'all' or [1,3,...]
%
%% method:read_to_struct
%%
%
%  data = obj.read_to_struct(filepath,zone,var)     read data by the infomation in the TEC_FILE_LOG
%                                                   filepath: '~' or new file path
%                                                   zone: 'all' or [1,3,...]
%                                                   var: 'all' or [1,3,...]
%