classdef TEC_FILE < liton_ordered_tec.TEC_FILE_BASE
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Zones;
        Echo_Mode; %file_head, file_end, variable, section, size, time, usingtime
        last_log;
    end
    
    methods
        function obj = TEC_FILE(varargin)
            if nargin == 0
                obj.FilePath = '.';
                obj.FileName = 'untitled_file';
                obj.Title = 'untitled';
                obj.FileType = 0;
                obj.Echo_Mode = 'brief';
            elseif nargin == 1
                if isempty(varargin{1})
                    ME = MException('TEC_FILE:TypeWrong', 'input of TEC_FILE constructor is empty');
                    throw(ME);
                end
                if isa(varargin{1},'numeric')
                    if isequal(mod(varargin{1},1),zeros(size(varargin{1})))
                        obj = repmat(liton_ordered_tec.TEC_FILE,varargin{1});
                    else
                        ME = MException('TEC_FILE:TypeWrong', 'input of TEC_FILE constructor must be a positive integer');
                        throw(ME);
                    end
                else
                    ME = MException('TEC_FILE:TypeWrong', 'TEC_FILE constructor type wrong (%s)',class(varargin{1}));
                    throw(ME);
                end
            else
                ME = MException('TEC_FILE:NArgInWrong', 'TEC_FILE constructor too many input arguments');
                throw(ME);
            end
        end
        
        function obj = set.Echo_Mode(obj, file_mode)
            if islogical(file_mode)
                if isequal(size(file_mode),[1,7])
                    obj.Echo_Mode = file_mode;
                elseif isequal(size(file_mode),[7,1])
                    obj.Echo_Mode = file_mode';
                else
                    ME = MException('TEC_FILE:InputWrong', 'echo_mode code size wrong');
                    throw(ME);
                end
            elseif ischar(file_mode)
                if strcmp(file_mode,'brief')
                    obj.Echo_Mode = logical([1,1,1,0,0,1,0]);
                elseif strcmp(file_mode,'full')
                    obj.Echo_Mode = true(1,7);
                elseif strcmp(file_mode,'simple')
                    obj.Echo_Mode = logical([1,0,0,0,0,1,0]);
                elseif strcmp(file_mode,'none')
                    obj.Echo_Mode = false(1,7);
                elseif strcmp(file_mode,'leave')
                else
                    ME = MException('TEC_FILE:InputWrong', 'echo_mode code string wrong ("%s")',file_mode);
                    throw(ME);
                end
            else
                ME = MException('TEC_FILE:TypeWrong', 'echo_mode type wrong (%s)',class(file_mode));
                throw(ME);
            end
        end
        
        function obj = set_echo_mode(obj, file_mode, zone_mode)
            if nargin == 1
                obj = obj.set_echo_mode('leave','leave');
            elseif nargin == 2
                obj = obj.set_echo_mode(file_mode,'leave');
            elseif nargin == 3
                obj.Echo_Mode = file_mode;
                for kk=1:numel(obj.Zones)
                    obj.Zones(kk).Echo_Mode = zone_mode;
                end
            else
                ME = MException('TEC_FILE:NArgInWrong', 'set_echo_mode too many or too few input arguments');
                throw(ME);
            end
        end
        
        function obj = write_plt(obj)
            tic
            obj.last_log = liton_ordered_tec.TEC_FILE_LOG(obj);
            obj.last_log.Time_Begin = datestr(now,30);
            
            obj = obj.wrtie_plt_pre();
            
            if obj.Echo_Mode(1)
                if obj.Echo_Mode(6)
                    buf = sprintf('[%s]',obj.last_log.Time_Begin);
                    e_l = length(obj.last_log.Echo_Text)+1;
                    obj.last_log.Echo_Text{e_l} = buf;
                    fprintf('%s',buf);
                end
                buf = sprintf('#### creat file %s/%s.plt ####', obj.FilePath, obj.FileName);
                if obj.Echo_Mode(6)
                    obj.last_log.Echo_Text{e_l} = [obj.last_log.Echo_Text{e_l},buf];
                    fprintf('%s\n',buf);
                else
                    e_l = length(obj.last_log.Echo_Text)+1;
                    obj.last_log.Echo_Text{e_l} = buf;
                    fprintf('%s\n',buf);
                end
            end
            fid = fopen([obj.FilePath,'/',obj.FileName,'.plt'],'wb');
            if fid==-1
                ME = MException('TEC_FILE:FileError', 'can not open file %s.plt',obj.FileName);
                throw(ME);
            end
            try
                % I    HEADER SECTION
                obj = obj.write_plt_head(fid);
                
                % EOHMARKER, value=357.0
                fwrite(fid,357.0,'float32');
                if obj.Echo_Mode(4)
                    buf = '-------------------------------------';
                    e_l = length(obj.last_log.Echo_Text)+1;
                    obj.last_log.Echo_Text{e_l} = buf;
                    fprintf('%s\n',buf);
                end
                
                % II   DATA SECTION
                obj = obj.write_plt_data(fid);
                
                pos = ftell(fid);
                obj.last_log.Size = pos/1024/1024;
                if obj.Echo_Mode(5)
                    buf = sprintf('     file size: %.1f MB',obj.last_log.Size);
                    e_l = length(obj.last_log.Echo_Text)+1;
                    obj.last_log.Echo_Text{e_l} = buf;
                    fprintf('%s\n',buf);
                end
                
                fclose(fid);
            catch ME
                fclose(fid);
                delete([obj.FileName,'.plt']);
                rethrow(ME)
            end
            
            obj.last_log.UsingTime = toc;
            if obj.Echo_Mode(7)
                buf = sprintf('     using time : %.5f s',obj.last_log.UsingTime);
                e_l = length(obj.last_log.Echo_Text)+1;
                obj.last_log.Echo_Text{e_l} = buf;
                fprintf('%s\n',buf);
            end
            
            obj.last_log.Time_End = datestr(now,30);
            if obj.Echo_Mode(2)
                if obj.Echo_Mode(6)
                    buf = sprintf('[%s]',obj.last_log.Time_End);
                    e_l = length(obj.last_log.Echo_Text)+1;
                    obj.last_log.Echo_Text{e_l} = buf;
                    fprintf('%s',buf);
                end
                buf = sprintf('#### creat file %s/%s.plt ####', obj.FilePath, obj.FileName);
                if obj.Echo_Mode(6)
                    e_l = length(obj.last_log.Echo_Text);
                    obj.last_log.Echo_Text{e_l} = [obj.last_log.Echo_Text{e_l},buf];
                    fprintf('%s\n',buf);
                else
                    e_l = length(obj.last_log.Echo_Text)+1;
                    obj.last_log.Echo_Text{e_l} = buf;
                    fprintf('%s\n',buf);
                end
            end
            
            obj.last_log = obj.last_log.gen_json();
            obj.last_log = obj.last_log.gen_xml();
        end
        
    end
    
    methods (Hidden = true)
        function obj = wrtie_plt_pre(obj)
            if isempty(obj.Variables)
                ME = MException('TEC_FILE:RuntimeError', ...
                    'FILE[%s]: TEC_FILE.Variables is empty',obj.FileName);
                throw(ME);
            end
            if isempty(obj.Zones)
                ME = MException('TEC_FILE:RuntimeError', ...
                    'FILE[%s]: TEC_FILE.Zones is empty',obj.FileName);
                throw(ME);
            end
            obj.last_log.Zones = liton_ordered_tec.TEC_ZONE_LOG(obj.Zones);
            for kk = 1:numel(obj.Zones)
                [obj.Zones(kk),obj.last_log.Zones(kk)] = obj.Zones(kk).wrtie_plt_pre(obj,obj.last_log.Zones(kk));
            end
        end
        
        function obj = write_plt_head(obj,fid)
            % I    HEADER SECTION
            % i    Magic number, Version number
            fwrite(fid,'#!TDV112','char*1');% 8 Bytes, exact characters "#!TDV112". Version number follows the "V" and consumes the next 3 characters (for example: "V75", "V101")
            % ii   Integer value of 1
            fwrite(fid,1,'int32');% This is used to determine the byte order of the reader, relative to the writer
            % iii  Title and variable names
            fwrite(fid,obj.FileType,'int32');% FileType 0 = FULL, 1 = GRID, 2 = SOLUTION
            fwrite(fid,liton_ordered_tec.s2i(obj.Title),'int32');% The TITLE
            fwrite(fid,numel(obj.Variables),'int32');% Number of variables (NumVar) in the datafile
            fwrite(fid,liton_ordered_tec.s2i(obj.Variables),'int32');% Variable names
            if obj.Echo_Mode(3)
                buf = '     VAR:';
                for kk = 1:numel(obj.Variables)
                    buf = [buf,' <',obj.Variables{kk},'>'];
                end
                e_l = length(obj.last_log.Echo_Text)+1;
                obj.last_log.Echo_Text{e_l} = buf;
                fprintf('%s\n',buf);
            end
            % iv   Zones
            for kk = 1:numel(obj.Zones)
                obj.Zones(kk).write_plt_head(fid);
            end
            % ix Dataset Auxiliary data
            if ~isempty(obj.Auxiliary)
                for au = obj.Auxiliary
                    fwrite(fid,799.0,'float32');% DataSetAux Marker
                    fwrite(fid,liton_ordered_tec.s2i(au{1}{1}),'int32');% Text for Auxiliary "Name"
                    fwrite(fid,0,'int32');% Auxiliary Value Format (Currently only allow 0=AuxDataType_String)
                    fwrite(fid,liton_ordered_tec.s2i(au{1}{2}),'int32');% Text for Auxiliary "Value"
                end
            end
        end
        
        function obj = write_plt_data(obj,fid)
            % II   DATA SECTION
            % i    For both ordered and fe zones
            for zone_n = 1:numel(obj.Zones)
                zone = obj.Zones(zone_n);
                if zone.Echo_Mode(1)
                    buf = sprintf('--   write zone %i: %s   --',zone_n,zone.ZoneName);
                    e_l = length(obj.last_log.Echo_Text)+1;
                    obj.last_log.Echo_Text{e_l} = buf;
                    fprintf('%s\n',buf);
                end
                
                obj.last_log.Zones(zone_n) = zone.write_plt_data(fid,obj,obj.last_log.Zones(zone_n));
                e_l = length(obj.last_log.Echo_Text)+1;
                obj.last_log.Echo_Text{e_l} = '#ZONE#';
                
                if zone.Echo_Mode(2)
                    buf = sprintf('--   write zone %i: %s   --',zone_n,zone.ZoneName);
                    e_l = length(obj.last_log.Echo_Text)+1;
                    obj.last_log.Echo_Text{e_l} = buf;
                    fprintf('%s\n',buf);
                end
            end
        end
        
    end
    
end
