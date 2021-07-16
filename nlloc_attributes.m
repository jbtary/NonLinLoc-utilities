% Processing of sum loc *.hyp location files from nonlinloc
% This uses AWK within Matlab (works in Mac and should also work in Linux)
% Tested for NLLoc v6 and v7
% 
% Input: 
%   path: path to the file(s) to process (ex: 'NG1D/')
%   filename: filename of the file to process (ex:
%   'LocOutputs.sum.grid0.loc.hyp')
%   phas: =1 if you want phase pick/residual info for each event
%   keyword: wildcard to search hyp nonlinloc files (ex:
%   'LocOutputs.2**grid0.loc.hyp'), careful to not include the final *.hyp
%   file!
%   flag: 1 for writing output to file
%   outname: path and filename of the output file
% Output:
%   locs: variable with earthquake location attributes as
% YYYY MM DD HH MM SS.SSS LAT LON DEPTH RMS NPH GAP DIST ERRH ERRZ
%   phs: cell array with phase file information for each *.hyp NLLOC event
%   file
% Station names, Phase type, Date, Hour, Secs, Residuals, Azimuths, Distances
% 

function [locs,phs] = nlloc_attributes(path,filename,phas,keyword,flag,outname)

[~,output] = system(['awk ''$1 ~ /^GEOGRAPHIC/'' ' path filename]);
geog = regexp(output,'GEOGRAPHIC','split');
geog = geog(1,2:end); clear output

[~,output] = system(['awk ''$1 ~ /^QUALITY/'' ' path filename]);
qual = regexp(output,'QUALITY','split');
qual = qual(1,2:end); clear output

[~,output] = system(['awk ''$1 ~ /^STATISTICS/'' ' path filename]);
stat = regexp(output,'STATISTICS','split');
stat = stat(1,2:end); clear output

[~,output] = system(['awk ''$1 ~ /^FOCALMECH/'' ' path filename]);
focm = regexp(output,'FOCALMECH','split');
focm = focm(1,2:end); clear output

for ii = 1:length(geog)
    
    % tmp = regexp(geog{1,ii},' ','split');
    tmp = regexp(geog{1,ii},'\d*','match');
    tmp2 = regexp(focm{1,ii},' ','split');
    % locs(ii,1:9) = [str2double(tmp{4}) str2double(tmp{5}) str2double(tmp{6}) ...
    %     str2double(tmp{8}) str2double(tmp{9}) str2double(tmp{10}) ...
    %     str2double(tmp{13}) str2double(tmp{15}) str2double(tmp{17})];
    locs(ii,1:9) = [str2double(tmp{1}) str2double(tmp{2}) str2double(tmp{3}) ...
        str2double(tmp{4}) str2double(tmp{5}) str2double([tmp{6} '.' tmp{7}]) ...
        str2double(tmp2{5}) str2double(tmp2{6}) str2double(tmp2{7})];
    clear tmp tmp2
    
    tmp = regexp(qual{1,ii},' ','split');
    locs(ii,10:13) = [str2double(tmp{10}) str2double(tmp{12}) str2double(tmp{14}) ...
        str2double(tmp{16})];
    clear tmp
    
    % Error estimation
    tmp = regexp(stat{1,ii},' ','split');
    errh = max([(sqrt(3.53 * str2double(tmp{11}))) (sqrt(3.53 * str2double(tmp{17})))]);
    errz = sqrt(3.53 * str2double(tmp{21}));
    locs(ii,14:15) = [errh errz];
    
    clear tmp err*
end

if phas == 1
    evhyps = dir([path keyword]);
    
    for ii = 1:length(evhyps)
        flag2 = 1; ind = 18; kk = 1;
        while flag2 > 0
            [~,output] = system(['awk ''NR==' num2str(ind) ' {print $0}'' ' path evhyps(ii).name]);
            tmp = regexp(output,' ','split');
            tmp = tmp(~cellfun('isempty',tmp));
            
            if length(tmp{1,1}) < 4; stan = [tmp{1,1} ' ']; else stan = tmp{1,1}; end
            phs(ii).stan{kk} = stan; % Station name
            phs(ii).phtype{kk} = tmp{1,5}; % Phase type
            phs(ii).Date{kk} = tmp{1,7}; % Date (yyyymmdd)
            phs(ii).HM{kk} = tmp{1,8}; % HourMinute
            phs(ii).Sec{kk} = tmp{1,9}; % Seconds
            phs(ii).Res{kk} = tmp{1,17}; % Residuals
            phs(ii).Az{kk} = str2double(tmp{1,23}); % Azimuth
            phs(ii).Dist{kk} = str2double(tmp{1,22}); % Distance (km)
            
            ind = ind + 1; kk = kk + 1;
            [~,output] = system(['awk ''NR==' num2str(ind) ' {print $0}'' ' path evhyps(ii).name]);
            if strcmp(output(1:9),'END_PHASE'); flag2 = 0; end
            clear output tmp stan
        end
    end
end

if flag == 1
    
    fid = fopen(outname,'w');
    % YYYY MM DD HH MM SS.SSS LAT LON DEPTH RMS NPH GAP DIST ERRH ERRZ
    fprintf(fid,'%s\n','Loc file format: YYYY MM DD HH MM SS.SSS LAT LON DEPTH RMS NPH GAP DIST ERRH ERRZ');
    fprintf(fid,'%d %d %d %d %d %2.3f %2.6f %3.6f %3.3f %1.2f %d %3.1f %3.1f %3.1f %3.1f\n',locs');
    fclose(fid);
    
end
