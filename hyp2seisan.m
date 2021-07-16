% Function to convert an output .hyp file from NLLOC to Seisan event file format
% Use AWK to perform the text import and some of the parsing
% 
% Input:
%   filename: path and filename of a .hyp file (ex: 
%   'path/to/my/file/LocOutputs.20160913.234848.grid0.loc.hyp')
% 
% Output Seisan S-file automatically created in current directory

function hyp2seisan(filename)

% Format of the header: JBT is just a 3-letters tag for operator/agency, and FF is 
% included to fix the location in Seisan (F: depth fixed, FF: hypocenter fixed)
format = ' %4i %2i%2i %02i%02i  %2.1f L  % 3.3f % 2.3f % 3.1fFFJBT %2i %1.1f 1.0LJBT                1\n';

% Get hypocenter data: YYYY MM DD HH MM SS.SSS LAT LON DEPTH RMS NPH GAP DIST ERRH ERRZ
% And phase info: STA PHA HHMM SS.SS AZI DIST
[loc,phs] = nlloc(filename);

% Seisan file name
outname = [num2str(loc(3),'%02i') '-' num2str(loc(4),'%02i') num2str(loc(5),'%02i') '-' ...
    num2str(floor(loc(6)),'%02i') 'L.S' num2str(loc(1),'%04i') num2str(loc(2),'%02i')];

fid = fopen(outname,'w');

fprintf(fid,format,[loc(1:9) loc(16) loc(10)]);
% Omitting the "ACTION" line
% id = [num2str(loc(1),'%4i') num2str(loc(2),'%02i') num2str(loc(3),'%02i') ...
%     num2str(loc(4),'%02i') num2str(loc(5),'%02i') num2str(floor(loc(6)),'%02i')];
% fprintf(fid,'%s\n',[' ACTION:NEW 01-12-19 10:10 OP:jbt  STATUS:               ID:' ...
%     id ' L   I']);
% Omitting the waveform filename line here
fprintf(fid,'%s\n',' STAT SP IPHASW D HRMM SECON CODA AMPLIT PERI AZIMU VELO AIN AR TRES W  DIS CAZ7');
% format = ' %s SZ E%s        % 2i% 2i % 2.2f                                             % 3i % 3i \n';

for ii = 1:size(phs,1)
    if strcmp(phs{ii,2},'?'); continue; end;
    hh = num2str(str2double(phs{ii,3}(1:end-2)),'% 2i');
    if length(hh) < 2; hh = [' ' hh]; end
    mm = num2str(str2double(phs{ii,3}(end-1:end)),'% 2i');
    if length(mm) < 2; mm = [' ' mm]; end
    ss = num2str(str2double(phs{ii,4}),'% 2.2f');
    if length(ss) < 5; ss = [' ' ss]; end
    % di = num2str(phs{ii,5},'%3i');
    % if length(di) == 2; di = [' ' di]; end
    % if length(di) == 1; di = ['  ' di]; end
    % az = num2str(phs{ii,6},'% 3i');
    % if length(az) == 2; az = [' ' az]; end
    % if length(az) == 1; az = ['  ' di]; end
    line = [' ' phs{ii,1}(1:2) phs{ii,1}(4:end) ' SZ I' phs{ii,2} '       ' hh ...
        mm ' ' ss '                                                   '];
    fprintf(fid,'%s\n',line); clear line hh mm ss di az
end
fclose(fid);

function [locs,phs] = nlloc(filename)

[~,output] = system(['awk ''$1 ~ /^GEOGRAPHIC/'' ' filename]);
geog = regexp(output,'GEOGRAPHIC','split');
geog = geog(1,2:end); clear output

[~,output] = system(['awk ''$1 ~ /^QUALITY/'' ' filename]);
qual = regexp(output,'QUALITY','split');
qual = qual(1,2:end); clear output

[~,output] = system(['awk ''$1 ~ /^STATISTICS/'' ' filename]);
stat = regexp(output,'STATISTICS','split');
stat = stat(1,2:end); clear output

[~,output] = system(['awk ''$1 ~ /^QML_OriginQuality/'' ' filename]);
qml = regexp(output,'QML_OriginQuality','split');
qml = qml(1,2:end); clear output
    
tmp = regexp(geog{1,1},' ','split');
locs(1,1:9) = [str2double(tmp{4}) str2double(tmp{5}) str2double(tmp{6}) ...
    str2double(tmp{8}) str2double(tmp{9}) str2double(tmp{10}) ...
    str2double(tmp{13}) str2double(tmp{15}) str2double(tmp{17})];
clear tmp

tmp = regexp(qual{1,1},' ','split');
locs(1,10:13) = [str2double(tmp{10}) str2double(tmp{12}) str2double(tmp{14}) ...
    str2double(tmp{16})];
clear tmp

tmp = regexp(stat{1,1},' ','split');
errh = max([(sqrt(3.53 * str2double(tmp{11}))) (sqrt(3.53 * str2double(tmp{17})))]);
errz = sqrt(3.53 * str2double(tmp{21}));
locs(1,14:15) = [errh errz];
clear tmp err*

tmp = regexp(qml{1,1},' ','split');
locs(1,16) = str2double(tmp{13});
clear tmp

flag = 1; ind = 18; kk = 1;
while flag > 0
    [~,output] = system(['awk ''NR==' num2str(ind) ' {print $0}'' ' filename]);
    tmp = regexp(output,' ','split');
    tmp = tmp(~cellfun('isempty',tmp));
    
    if length(tmp{1,1}) < 4; stan = [tmp{1,1} ' ']; else stan = tmp{1,1}; end
    phs{kk,1} = stan; % Station name
    phs{kk,2} = tmp{1,5}; % Phase type
    phs{kk,3} = tmp{1,8}; % HourMinute
    phs{kk,4} = tmp{1,9}; % Seconds
    phs{kk,5} = round(str2double(tmp{1,23})); % Azimuth
    phs{kk,6} = round(str2double(tmp{1,22})); % Distance (km)
    
    ind = ind + 1; kk = kk + 1;
    [~,output] = system(['awk ''NR==' num2str(ind) ' {print $0}'' ' filename]);
    if strcmp(output(1:9),'END_PHASE'); flag = 0; end
    clear output tmp stan
end
