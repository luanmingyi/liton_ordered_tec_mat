classdef TEC_FILE_LOG < liton_ordered_tec.TEC_FILE_BASE
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Time_Begin;
        Time_End;
        UsingTime;
        Size;
        Echo_Text;
        Json_Text;
        Xml_Text;
        Zones;
    end
    
    methods
        function obj = TEC_FILE_LOG(varargin)
            if nargin==0
            elseif nargin==1
                if isempty(varargin{1})
                    ME = MException('TEC_FILE_LOG:TypeWrong', 'input of TEC_FILE_LOG constructor is empty');
                    throw(ME);
                end
                if isa(varargin{1},'liton_ordered_tec.TEC_FILE')
                    if isscalar(varargin{1})
                        tec_file = varargin{1};
                        obj.FilePath = tec_file.FilePath;
                        obj.FileName = tec_file.FileName;
                        obj.Title = tec_file.Title;
                        obj.Variables = tec_file.Variables;
                        obj.FileType = tec_file.FileType;
                        obj.Auxiliary = tec_file.Auxiliary;
                    else
                        tec_file_m = varargin{1};
                        obj = repmat(liton_ordered_tec.TEC_FILE_LOG,size(tec_file_m));
                        for kk = 1:numel(tec_file_m)
                            obj(kk) = liton_ordered_tec.TEC_FILE_LOG(tec_file_m(kk));
                        end
                    end
                elseif isa(varargin{1},'numeric')
                    if isequal(mod(varargin{1},1),zeros(size(varargin{1})))
                        obj = repmat(liton_ordered_tec.TEC_FILE_LOG,varargin{1});
                    else
                        ME = MException('TEC_FILE_LOG:TypeWrong', 'input of TEC_FILE_LOG constructor must be a positive integer');
                        throw(ME);
                    end
                else
                    ME = MException('TEC_FILE_LOG:TypeWrong', 'TEC_FILE_LOG constructor type wrong (%s)',class(varargin{1}));
                    throw(ME);
                end
            else
                ME = MException('TEC_FILE_LOG:NArgInWrong', 'TEC_FILE_LOG constructor too many input arguments');
                throw(ME);
            end
        end
        
        function write_echo(obj,fid)
            if nargin==1
                fid = fopen(fullfile(obj.FilePath,[obj.FileName,'.txt']),'w');
                if fid==-1
                    ME = MException('TEC_FILE_LOG:FileError', 'can not open file %s.txt',obj.FileName);
                    throw(ME);
                end
                obj.write_echo(fid);
                fclose(fid);
            elseif nargin==2
                zone_n = 0;
                for ss = obj.Echo_Text
                    if strcmp(ss{1},'#ZONE#')
                        zone_n = zone_n + 1;
                        obj.Zones(zone_n).write_echo(fid);
                    else
                        fprintf(fid,'%s\n',ss{1});
                    end
                end
            else
                ME = MException('TEC_FILE_LOG:NArgInWrong', 'too many input arguments');
                throw(ME);
            end
        end
        
        function write_json(obj,depth,fid)
            if nargin==1
                depth = 0;
                obj.write_json(depth);
            elseif nargin==2
                fid = fopen(fullfile(obj.FilePath,[obj.FileName,'.json']),'w');
                if fid==-1
                    ME = MException('TEC_FILE_LOG:FileError', 'can not open file %s.json',obj.FileName);
                    throw(ME);
                end
                obj.write_json(depth,fid);
                fclose(fid);
            elseif nargin==3
                zone_n = 0;
                for ss = obj.Json_Text
                    fprintf(fid,repmat('\t',1,depth));
                    if strcmp(ss{1},'#ZONE#')
                        zone_n = zone_n + 1;
                        obj.Zones(zone_n).write_json(depth+2,fid);
                    else
                        fprintf(fid,'%s\n',ss{1});
                    end
                end
            else
                ME = MException('TEC_FILE_LOG:NArgInWrong', 'too many input arguments');
                throw(ME);
            end
        end
        
        function write_xml(obj,depth,fid)
            if nargin==1
                depth = 0;
                obj.write_xml(depth);
            elseif nargin==2
                fid = fopen(fullfile(obj.FilePath,[obj.FileName,'.xml']),'w');
                if fid==-1
                    ME = MException('TEC_FILE_LOG:FileError', 'can not open file %s.xml',obj.FileName);
                    throw(ME);
                end
                fprintf(fid,'<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n');
                obj.write_xml(depth,fid);
                fclose(fid);
            elseif nargin==3
                zone_n = 0;
                for ss = obj.Xml_Text
                    fprintf(fid,repmat('\t',1,depth));
                    if strcmp(ss{1},'#ZONE#')
                        zone_n = zone_n + 1;
                        obj.Zones(zone_n).write_xml(depth+2,fid);
                    else
                        fprintf(fid,'%s\n',ss{1});
                    end
                end
            else
                ME = MException('TEC_FILE_LOG:NArgInWrong', 'too many input arguments');
                throw(ME);
            end
        end
        
        function obj = read_xml(obj,file_root)
            if isa(file_root,'char')
                doc = xmlread(file_root);
                obj = obj.read_xml(doc.getDocumentElement);
            else
                obj.FileName = char(file_root.getAttribute('FileName'));
                obj.FilePath = char(file_root.getElementsByTagName('FilePath').item(0).getTextContent);
                obj.Time_Begin = char(file_root.getElementsByTagName('Time').item(0).getTextContent);
                obj.UsingTime = str2double(file_root.getElementsByTagName('UsingTime').item(0).getTextContent);
                obj.Title = char(file_root.getElementsByTagName('Title').item(0).getTextContent);
                obj.FileType = str2double(file_root.getElementsByTagName('FileType').item(0).getTextContent);
                
                temp = file_root.getElementsByTagName('Variables').item(0).getFirstChild;
                v_n = 0;
                while ~isempty(temp)
                    if temp.getNodeType~=temp.TEXT_NODE
                        v_n = v_n + 1;
                        obj.Variables{v_n} = char(temp.getNodeName);
                    end
                    temp = temp.getNextSibling;
                end
                
                temp = file_root.getElementsByTagName('Auxiliary');
                if temp.getLength~=0
                    temp = temp.item(0).getFirstChild;
                    v_n = 0;
                    while ~isempty(temp)
                        if temp.getNodeType~=temp.TEXT_NODE
                            v_n = v_n + 1;
                            obj.Auxiliary{v_n} = {char(temp.getNodeName), char(temp.getTextContent)};
                        end
                        temp = temp.getNextSibling;
                    end
                end
                
                temp = file_root.getElementsByTagName('Zones').item(0).getFirstChild;
                obj.Zones = liton_ordered_tec.TEC_ZONE_LOG;
                v_n = 0;
                while ~isempty(temp)
                    if temp.getNodeType~=temp.TEXT_NODE
                        v_n = v_n + 1;
                        obj.Zones(v_n) = liton_ordered_tec.TEC_ZONE_LOG;
                        obj.Zones(v_n) = obj.Zones(v_n).read_xml(temp);
                    end
                    temp = temp.getNextSibling;
                end
                
                obj = obj.gen_xml();
                obj = obj.gen_json();
            end
        end
        
        function data = read_to_cell(obj,filepath,zone,var)
            if strcmp(filepath,'~')
                filepath = obj.FilePath;
            end
            if strcmp(zone,'all')
                zone = 1:numel(obj.Zones);
            end
            if strcmp(var,'all')
                var = 1:length(obj.Variables);
            end
            
            fid = fopen(fullfile(filepath,[obj.FileName,'.plt']),'rb');
            if fid==-1
                ME = MException('TEC_FILE_LOG:FileError', ['cannot open file ',filepath,' ',obj.FileName]);
                throw(ME);
            end
            try
                data{length(zone)} = [];
                for k=1:length(zone)
                    data{k} = obj.Zones(zone(k)).read_to_cell(fid,var);
                end
            catch ME
                fclose(fid);
                rethrow(ME)
            end
            fclose(fid);
        end
        
        function data = read_to_struct(obj,filepath,zone,var)
            if length(unique(obj.Variables))~=length(obj.Variables)
                ME = MException('TEC_FILE_LOG:RuntimeError', 'exist same variable name');
                throw(ME);
            end
            if strcmp(zone,'all')
                zone = 1:numel(obj.Zones);
            end
            if strcmp(var,'all')
                var = 1:length(obj.Variables);
            end
            data_temp = read_to_cell(obj,filepath,zone,var);
            for k=1:length(zone)
                for n=1:length(var)
                    data(k).(obj.Variables{var(n)}) = data_temp{k}{n};
                end
            end
        end
        
    end
    
    methods (Hidden = true)
        function obj = gen_json(obj)
            obj.Json_Text = [];
            obj.Json_Text{end+1} = '{';
            buf = sprintf('\t"FileName" : "%s.plt" ,',obj.FileName); obj.Json_Text{end+1} = buf;
            buf = sprintf('\t"FilePath" : "%s" ,',obj.FilePath); obj.Json_Text{end+1} = buf;
            buf = sprintf('\t"Time" : "%s" ,', obj.Time_Begin); obj.Json_Text{end+1} = buf;
            buf = sprintf('\t"UsingTime" : %.5f ,', obj.UsingTime); obj.Json_Text{end+1} = buf;
            buf = sprintf('\t"Title" : "%s" ,', obj.Title); obj.Json_Text{end+1} = buf;
            buf = sprintf('\t"FileType_comment" : "0 = FULL, 1 = GRID, 2 = SOLUTION" ,'); obj.Json_Text{end+1} = buf;
            buf = sprintf('\t"FileType" : %i ,', obj.FileType); obj.Json_Text{end+1} = buf;
            
            buf = sprintf('\t"Variables" : [ '); obj.Json_Text{end+1} = buf;
            for v_n = 1:numel(obj.Variables)
                obj.Json_Text{end} = [obj.Json_Text{end},'"',obj.Variables{v_n},'"'];
                if v_n ~= numel(obj.Variables)
                    obj.Json_Text{end} = [obj.Json_Text{end},', '];
                end
            end
            obj.Json_Text{end} = [obj.Json_Text{end},' ] ,'];
            
            if ~isempty(obj.Auxiliary)
                buf  = sprintf('\t"Auxiliary" : {'); obj.Json_Text{end+1} = buf;
                for kk = 1:length(obj.Auxiliary)
                    buf = sprintf('\t\t"%s" : "%s"',obj.Auxiliary{kk}{1},obj.Auxiliary{kk}{2});
                    obj.Json_Text{end+1} = buf;
                    if kk~= length(obj.Auxiliary)
                        obj.Json_Text{end} = [obj.Json_Text{end},','];
                    end
                end
                buf  = sprintf('\t} ,'); obj.Json_Text{end+1} = buf;
            end
            
            buf = sprintf('\t"Zones" : ['); obj.Json_Text{end+1} = buf;
            for z_n = 1:numel(obj.Zones)
                obj.Zones(z_n) = obj.Zones(z_n).gen_json();
                obj.Json_Text{end+1} = '#ZONE#';
                if z_n~=numel(obj.Zones)
                    buf = sprintf('\t\t,'); obj.Json_Text{end+1} = buf;
                end
            end
            buf = sprintf('\t]'); obj.Json_Text{end+1} = buf;
            
            buf = sprintf('}'); obj.Json_Text{end+1} = buf;
        end
        
        function obj = gen_xml(obj)
            obj.Xml_Text = [];
            buf = sprintf('<File FileName="%s">',obj.FileName); obj.Xml_Text{end+1} = buf;
            
            buf = sprintf('\t<FileName>%s</FileName>', [obj.FileName,'.plt']); obj.Xml_Text{end+1} = buf;
            buf = sprintf('\t<FilePath>%s</FilePath>', obj.FilePath); obj.Xml_Text{end+1} = buf;
            buf = sprintf('\t<Time>%s</Time>', obj.Time_Begin); obj.Xml_Text{end+1} = buf;
            buf = sprintf('\t<UsingTime>%.5f</UsingTime>', obj.UsingTime); obj.Xml_Text{end+1} = buf;
            buf = sprintf('\t<Title>%s</Title>', obj.Title); obj.Xml_Text{end+1} = buf;
            buf = sprintf('\t<!--%s-->', '0 = FULL, 1 = GRID, 2 = SOLUTION'); obj.Xml_Text{end+1} = buf;
            buf = sprintf('\t<FileType>%i</FileType>', obj.FileType); obj.Xml_Text{end+1} = buf;
            
            buf = sprintf('\t<Variables>'); obj.Xml_Text{end+1} = buf;
            for v_n = 1:numel(obj.Variables)
                buf = sprintf(' <%s i="%i"/>',obj.Variables{v_n},v_n-1);
                obj.Xml_Text{end} = [obj.Xml_Text{end},buf];
            end
            obj.Xml_Text{end} = [obj.Xml_Text{end},' </Variables>'];
            
            if ~isempty(obj.Auxiliary)
                buf  = sprintf('\t<Auxiliary>'); obj.Xml_Text{end+1} = buf;
                for kk = 1:length(obj.Auxiliary)
                    buf = sprintf('\t\t<%s>%s</%s>',obj.Auxiliary{kk}{1},obj.Auxiliary{kk}{2},obj.Auxiliary{kk}{1});
                    obj.Xml_Text{end+1} = buf;
                end
                buf  = sprintf('\t</Auxiliary>'); obj.Xml_Text{end+1} = buf;
            end
            
            buf = sprintf('\t<Zones>'); obj.Xml_Text{end+1} = buf;
            for z_n = 1:numel(obj.Zones)
                obj.Zones(z_n) = obj.Zones(z_n).gen_xml();
                obj.Xml_Text{end+1} = '#ZONE#';
            end
            buf = sprintf('\t</Zones>'); obj.Xml_Text{end+1} = buf;
            
            buf = sprintf('</File>'); obj.Xml_Text{end+1} = buf;
        end
        
    end
    
end

