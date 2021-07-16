%%

clear
path = '/Users/jeanbaptistetary/Documents/JC114/NG1D/TTimesFrom1DVelmods/';
direcs = dir([path '*0*']);

for ii = 2:length(direcs)
    copyfile([path 'NG040/nlloc_jc114_1d.in'],[path direcs(ii).name])
    mkdir([path direcs(ii).name '/Velmod'])
    mkdir([path direcs(ii).name '/TTimes'])
end

%% NG
clear; clc;
d = 2.96 - 0.01; % Just above the depth of OBS to be sure to have them in the ground

disp(' -- ')
disp('LAYER   0.00  1.500 0.000    0.010  0.000  1.00 0.0')
disp(['LAYER   ' num2str(d,'%1.2f') '  3.593 2.560    1.996  1.422  2.41 0.0'])
disp(['LAYER   ' num2str(d+0.2,'%1.2f') '  4.105 1.590    2.281  0.883  2.41 0.0'])
disp(['LAYER   ' num2str(d+0.6,'%1.2f') '  4.741 1.702    2.634  0.945  2.41 0.0'])
disp(['LAYER   ' num2str(d+1.25,'%1.2f') '  5.847 1.393    3.248  0.774  2.78 0.0'])
disp(['LAYER   ' num2str(d+1.39,'%1.2f') '  6.042 0.655    3.357  0.364  2.78 0.0'])
disp(['LAYER   ' num2str(d+1.61,'%1.2f') '  6.186 0.990    3.437  0.550  2.88 0.0'])
disp(['LAYER   ' num2str(d+1.9,'%1.2f') '  6.473 0.310    3.596  0.172  2.88 0.0'])
disp(['LAYER   ' num2str(d+2.1,'%1.2f') '  6.535 0.169    3.631  0.094  2.88 0.0'])
disp(['LAYER   ' num2str(d+4,'%1.2f') '  6.857 0.203    3.809  0.113  2.94 0.0'])
disp(['LAYER   ' num2str(d+9.2,'%1.2f') '  8.000 0.000    4.444  0.000  3.00 0.0'])
disp(' -- ')

%% Create input file for NNLOC

clear
d = 3.45 - 0.01; % Just above the depth of OBS to be sure to have them in the ground
path = '/Users/jeanbaptistetary/Documents/JC114/NG1D/TTimesFrom1DVelmods/SG075/nlloc_jc114_1d.in';

% Write to file
fid = fopen(path,'w');
fprintf(fid,'%s\n','# Simplified NNLOC file');

fprintf(fid,'%s\n','CONTROL 1 54321');

fprintf(fid,'%s\n','#TRANS  LAMBERT  WGS-84  7.2433 -76.4358  2  9  0.0');
fprintf(fid,'%s\n','#TRANS  SIMPLE  7.2433 -76.4358  0.0');
fprintf(fid,'%s\n','TRANS  SIMPLE  3.0436111 -84.0  0.0');

fprintf(fid,'%s\n','# Vel2Grid');
fprintf(fid,'%s\n','#VGOUT  /Users/karl/Documents/NLLOC/JC114/Velmod/velmod');
fprintf(fid,'%s\n','VGOUT  /Users/jeanbaptistetary/Documents/JC114/NG1D/Velmod/velmod');

fprintf(fid,'%s\n','VGGRID  2 7500 375  0.0 0.0 -1.0  0.2 0.2 0.2  SLOW_LEN');

fprintf(fid,'%s\n','VGTYPE P');
fprintf(fid,'%s\n','VGTYPE S');

fprintf(fid,'%s\n','# Velocity structure off-axis of CRR from 3D model of Robinson paper');
fprintf(fid,'%s\n','# See excel file velmod1d_invoffaxis');
fprintf(fid,'%s\n','LAYER   0.00  1.500 0.000    0.010  0.000  1.00 0.0');
fprintf(fid,'%s\n',['LAYER   ' num2str(d,'%1.2f') '  3.593 2.560    1.996  1.422  2.41 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+0.2,'%1.2f') '  4.105 1.590    2.281  0.883  2.41 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+0.6,'%1.2f') '  4.741 1.702    2.634  0.945  2.41 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+1.25,'%1.2f') '  5.847 1.393    3.248  0.774  2.78 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+1.39,'%1.2f') '  6.042 0.655    3.357  0.364  2.78 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+1.61,'%1.2f') '  6.186 0.990    3.437  0.550  2.88 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+1.9,'%1.2f') '  6.473 0.310    3.596  0.172  2.88 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+2.1,'%1.2f') '  6.535 0.169    3.631  0.094  2.88 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+4,'%1.2f') '  6.857 0.203    3.809  0.113  2.94 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+9.2,'%1.2f') '  8.000 0.000    4.444  0.000  3.00 0.0']);

fprintf(fid,'%s\n','# Velocity model (iasp91)');
fprintf(fid,'%s\n','#LAYER   0.0  5.8 0.00    3.36  0.00  2.7 0.0');
fprintf(fid,'%s\n','#LAYER  20.0  6.5 0.00    3.75  0.00  2.7 0.0');
fprintf(fid,'%s\n','#LAYER  35.0  8.04 0.00    4.47  0.00  2.7 0.0');
fprintf(fid,'%s\n','#LAYER  40.0  8.0406 0.00    4.47  0.00  2.7 0.0');
fprintf(fid,'%s\n','#LAYER  45.0  8.0412 0.00    4.47  0.00  2.7 0.0');
fprintf(fid,'%s\n','#LAYER  50.0  8.0418 0.00    4.48  0.00  2.7 0.0');

fprintf(fid,'%s\n','# Grid2Time');
fprintf(fid,'%s\n','#GTFILES  /Users/jeanbaptistetary/Documents/JC114/NG1D/Velmod/velmod  /Users/jeanbaptistetary/Documents/JC114/NG1D/TTimes/ttimes P');

fprintf(fid,'%s\n','GTFILES  /Users/jeanbaptistetary/Documents/JC114/NG1D/Velmod/velmod  /Users/jeanbaptistetary/Documents/JC114/NG1D/TTimes/ttimes S');

fprintf(fid,'%s\n','GTMODE GRID2D ANGLES_YES');

fprintf(fid,'%s\n','# Stations: option chosen is 0 of velocity model at depth of shallower OBS');
fprintf(fid,'%s\n','# From excel file sta_coordinates');
fprintf(fid,'%s\n','GTSRCE NG069 LATLON 3.36572468 -83.68856790 0 -2.988');
fprintf(fid,'%s\n','GTSRCE NG062 LATLON 3.36915446 -83.73410558 0 -3.003');
fprintf(fid,'%s\n','GTSRCE NG072 LATLON 3.36979436 -83.77914866 0 -3.028');
fprintf(fid,'%s\n','GTSRCE NG057 LATLON 3.37043156 -83.81941721 0 -2.963');
fprintf(fid,'%s\n','GTSRCE NG058 LATLON 3.36913495 -83.86896497 0 -2.906');
fprintf(fid,'%s\n','GTSRCE NG067 LATLON 3.33374714 -83.86887936 0 -2.998');
fprintf(fid,'%s\n','GTSRCE NG063 LATLON 3.32978400 -83.82654080 0 -2.972');
fprintf(fid,'%s\n','GTSRCE NG046 LATLON 3.33303969 -83.77951673 0 -2.95');
fprintf(fid,'%s\n','GTSRCE NG047 LATLON 3.34190553 -83.73456288 0 -2.979');
fprintf(fid,'%s\n','GTSRCE NG065 LATLON 3.32835913 -83.69110124 0 -3.102');
fprintf(fid,'%s\n','GTSRCE NG076 LATLON 3.28485820 -83.69044962 0 -2.973');
fprintf(fid,'%s\n','GTSRCE NG073 LATLON 3.28938636 -83.73700826 0 -3.104');
fprintf(fid,'%s\n','GTSRCE NG070 LATLON 3.28579932 -83.78182367 0 -3.013');
fprintf(fid,'%s\n','GTSRCE NG040 LATLON 3.28801134 -83.82879973 0 -2.949');
fprintf(fid,'%s\n','GTSRCE NG054 LATLON 3.28887194 -83.87248823 0 -2.97');
fprintf(fid,'%s\n','GTSRCE NG074 LATLON 3.24381610 -83.87105256 0 -2.859');
fprintf(fid,'%s\n','GTSRCE NG044 LATLON 3.24767670 -83.82646436 0 -2.85');
fprintf(fid,'%s\n','GTSRCE NG068 LATLON 3.24308059 -83.77570739 0 -2.98');
fprintf(fid,'%s\n','GTSRCE NG051 LATLON 3.24959172 -83.73710827 0 -3.015');
fprintf(fid,'%s\n','GTSRCE NG066 LATLON 3.24283387 -83.68918962 0 -3.097');
fprintf(fid,'%s\n','GTSRCE NG055 LATLON 3.19458626 -83.69172583 0 -2.826');
fprintf(fid,'%s\n','GTSRCE NG061 LATLON 3.20296111 -83.73293153 0 -2.868');
fprintf(fid,'%s\n','GTSRCE NG053 LATLON 3.18925721 -83.77923166 0 -2.845');
fprintf(fid,'%s\n','GTSRCE NG075 LATLON 3.20037250 -83.82557149 0 -2.678');
fprintf(fid,'%s\n','GTSRCE NG071 LATLON 3.19988448 -83.87105803 0 -2.695');
fprintf(fid,'%s\n','GTSRCE SA060 LATLON 3.53273294 -83.83619148 0 -2.624');
fprintf(fid,'%s\n','GTSRCE SA050 LATLON 3.45295039 -83.83168065 0 -2.702');
fprintf(fid,'%s\n','GTSRCE SA058 LATLON 3.10923841 -83.81556625 0 -2.96');
fprintf(fid,'%s\n','GTSRCE SA072 LATLON 3.02615000 -83.81331667 0 -2.688');
fprintf(fid,'%s\n','GTSRCE SA022 LATLON 2.94045031 -83.80933351 0 -2.901');
fprintf(fid,'%s\n','GTSRCE SA062 LATLON 2.86641697 -83.80560058 0 -3.195');
fprintf(fid,'%s\n','GTSRCE SA023 LATLON 2.78472014 -83.80194449 0 -3.117');
fprintf(fid,'%s\n','GTSRCE SA069 LATLON 2.70397029 -83.79881792 0 -3.288');
fprintf(fid,'%s\n','GTSRCE SA005 LATLON 2.62169460 -83.79487622 0 -3.309');
fprintf(fid,'%s\n','GTSRCE SA065 LATLON 2.54014847 -83.79173299 0 -3.245');
fprintf(fid,'%s\n','GTSRCE SA017 LATLON 2.45925275 -83.78844439 0 -3.322');
fprintf(fid,'%s\n','GTSRCE SA047 LATLON 2.37778634 -83.78557381 0 -3.409');
fprintf(fid,'%s\n','GTSRCE SA001 LATLON 2.29666602 -83.78108385 0 -3.44');
fprintf(fid,'%s\n','GTSRCE SA046 LATLON 2.21583284 -83.77729214 0 -3.21');
fprintf(fid,'%s\n','GTSRCE SA007 LATLON 2.13545959 -83.77368680 0 -3.309');
fprintf(fid,'%s\n','GTSRCE SA067 LATLON 2.05369468 -83.76977048 0 -3.37');
fprintf(fid,'%s\n','GTSRCE SA008 LATLON 1.97311256 -83.76608665 0 -3.276');
fprintf(fid,'%s\n','GTSRCE SA054 LATLON 1.89303551 -83.76266088 0 -3.456');
fprintf(fid,'%s\n','GTSRCE SA020 LATLON 1.81162159 -83.75852927 0 -3.213');
fprintf(fid,'%s\n','GTSRCE SA070 LATLON 1.73019767 -83.75461907 0 -3.195');
fprintf(fid,'%s\n','GTSRCE SA013 LATLON 1.64770591 -83.75135982 0 -3.214');
fprintf(fid,'%s\n','GTSRCE SA073 LATLON 1.56854986 -83.74685369 0 -3.471');
fprintf(fid,'%s\n','GTSRCE SA016 LATLON 1.48790000 -83.74391667 0 -3.434');
fprintf(fid,'%s\n','GTSRCE SA076 LATLON 1.40644682 -83.73998162 0 -3.551');
fprintf(fid,'%s\n','GTSRCE SA053 LATLON 1.06255233 -83.72588403 0 -3.416');
fprintf(fid,'%s\n','GTSRCE SG061 LATLON 1.32349814 -83.69018900 0 -3.487');
fprintf(fid,'%s\n','GTSRCE SG066 LATLON 1.32432667 -83.73314800 0 -3.452');
fprintf(fid,'%s\n','GTSRCE SG055 LATLON 1.32468361 -83.77821884 0 -3.425');
fprintf(fid,'%s\n','GTSRCE SG060 LATLON 1.32472186 -83.82399043 0 -3.422');
fprintf(fid,'%s\n','GTSRCE SG050 LATLON 1.32444551 -83.86761414 0 -3.421');
fprintf(fid,'%s\n','GTSRCE SG057 LATLON 1.27826415 -83.86673600 0 -3.469');
fprintf(fid,'%s\n','GTSRCE SG063 LATLON 1.28109371 -83.82515384 0 -3.452');
fprintf(fid,'%s\n','GTSRCE SG040 LATLON 1.28020480 -83.77895121 0 -3.463');
fprintf(fid,'%s\n','GTSRCE SG051 LATLON 1.27939692 -83.73217226 0 -3.47');
fprintf(fid,'%s\n','GTSRCE SG044 LATLON 1.28179327 -83.68831302 0 -3.43');
fprintf(fid,'%s\n','GTSRCE SG075 LATLON 1.23502573 -83.68805859 0 -3.445');
fprintf(fid,'%s\n','GTSRCE SG068 LATLON 1.23398578 -83.73273558 0 -3.444');
fprintf(fid,'%s\n','GTSRCE SG058 LATLON 1.23411985 -83.77747492 0 -3.426');
fprintf(fid,'%s\n','GTSRCE SG052 LATLON 1.23412706 -83.82181741 0 -3.449');
fprintf(fid,'%s\n','GTSRCE SG062 LATLON 1.23294800 -83.86783571 0 -3.491');
fprintf(fid,'%s\n','GTSRCE SG069 LATLON 1.18783187 -83.86784214 0 -3.426');
fprintf(fid,'%s\n','GTSRCE SG065 LATLON 1.18729891 -83.82411213 0 -3.426');
fprintf(fid,'%s\n','GTSRCE SG047 LATLON 1.18747056 -83.77989637 0 -3.385');
fprintf(fid,'%s\n','GTSRCE SG074 LATLON 1.18897303 -83.73256475 0 -3.419');
fprintf(fid,'%s\n','GTSRCE SG045 LATLON 1.18753316 -83.68986137 0 -3.405');
fprintf(fid,'%s\n','GTSRCE SG067 LATLON 1.14238372 -83.68916309 0 -3.429');
fprintf(fid,'%s\n','GTSRCE SG071 LATLON 1.14331810 -83.73295164 0 -3.452');
fprintf(fid,'%s\n','GTSRCE SG054 LATLON 1.14205302 -83.77964534 0 -3.407');
fprintf(fid,'%s\n','GTSRCE SG070 LATLON 1.14171978 -83.82453356 0 -3.417');
fprintf(fid,'%s\n','GTSRCE SG073 LATLON 1.14176535 -83.86944734 0 -3.49');

fprintf(fid,'%s\n','# Podvin & Lecomte FD params');
fprintf(fid,'%s\n','GT_PLFD  1.0e-3  0');

fclose(fid);

%% Copy created TTimes grid files to another folder

clear
path1 = '/Users/jeanbaptistetary/Documents/JC114/NG1D/TTimesFrom1DVelmods/';
path2 = '/Users/jeanbaptistetary/Documents/JC114/NG1D/TTimes';
direcs = dir([path1 '*0*']);

for ii = 1:length(direcs)
    
    copyfile([path1 direcs(ii).name '/TTimes/*angle*'],path2)
    copyfile([path1 direcs(ii).name '/TTimes/*.time*'],path2)
    
end

%% SG
clear; clc;
d = 3.21 - 0.01; % Just above the depth of OBS to be sure to have them in the ground

% Vp/Vs ratio of about 1.755 from average Poisson ratio of E. Gregory 0.26
% Layer depth velP dvelP velS dvelS density d_density
disp(' -- ')
disp('LAYER   0.00  1.500 0.000    0.010  0.000  1.00 0.0')
disp(['LAYER   ' num2str(d,'%1.2f') '  1.680 0.000    0.957  0.000  2.20 0.0'])
disp(['LAYER   ' num2str(d+0.3,'%1.2f') '  4.947 0.001    2.819  0.0006  2.41 0.0'])
disp(['LAYER   ' num2str(d+0.8,'%1.2f') '  5.353 0.003    3.050  0.002  2.41 0.0'])
disp(['LAYER   ' num2str(d+1.0,'%1.2f') '  5.853 0.001    3.335  0.0006  2.78 0.0'])
disp(['LAYER   ' num2str(d+1.3,'%1.2f') '  6.202 0.0006    3.534  0.0003  2.88 0.0'])
disp(['LAYER   ' num2str(d+2.2,'%1.2f') '  6.717 0.0004    3.827  0.0002  2.94 0.0'])
disp(['LAYER   ' num2str(d+2.7,'%1.2f') '  6.928 0.0001    3.948  0.0001  2.94 0.0'])
disp(['LAYER   ' num2str(d+4.6,'%1.2f') '  7.213 0.000    4.110  0.000  2.94 0.0'])
disp(['LAYER   ' num2str(d+5.3,'%1.2f') '  7.900 0.000    4.501  0.000  2.94 0.0'])
disp(['LAYER   ' num2str(d+6.2,'%1.2f') '  8.000 0.020    4.558  0.011  3.00 0.0'])
disp(' -- ')

%% SG partial input file

clear
d = 3.445 - 0.01; % Just above the depth of OBS to be sure to have them in the ground
path = '/Users/karl/Documents/NLLOC/JC114/SG1D/TTimesFrom1DVelmods/SG075/nlloc_jc114_1d.in';

% Write to file
fid = fopen(path,'w');
fprintf(fid,'%s\n','# Simplified NNLOC file');

fprintf(fid,'%s\n','CONTROL 1 54321');

fprintf(fid,'%s\n','TRANS  SIMPLE  1.23411984938987  -83.7774749200674  0.0');

fprintf(fid,'%s\n','# Vel2Grid');
fprintf(fid,'%s\n','VGOUT  /Users/karl/Documents/NLLOC/JC114/SG1D/TTimesFrom1DVelmods/velmod');
fprintf(fid,'%s\n','#VGOUT  /Users/jeanbaptistetary/Documents/JC114/NG1D/Velmod/velmod');

fprintf(fid,'%s\n','VGGRID  2 3000 200  0.0 0.0 0.0  0.2 0.2 0.2 SLOW_LEN');

fprintf(fid,'%s\n','VGTYPE P');
fprintf(fid,'%s\n','VGTYPE S');

fprintf(fid,'%s\n','# Velocity structure');
fprintf(fid,'%s\n','LAYER   0.00  1.500 0.000    0.010  0.000  1.00 0.0');
fprintf(fid,'%s\n',['LAYER   ' num2str(d,'%1.2f') '  1.680 0.000    0.957  0.000  2.20 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+0.3,'%1.2f') '  4.947 0.001    2.819  0.0006  2.41 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+0.8,'%1.2f') '  5.353 0.003    3.050  0.002  2.41 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+1.0,'%1.2f') '  5.853 0.001    3.335  0.0006  2.78 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+1.3,'%1.2f') '  6.202 0.0006    3.534  0.0003  2.88 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+2.2,'%1.2f') '  6.717 0.0004    3.827  0.0002  2.94 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+2.7,'%1.2f') '  6.928 0.0001    3.948  0.0001  2.94 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+4.6,'%1.2f') '  7.213 0.000    4.110  0.000  2.94 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+5.3,'%1.2f') '  7.900 0.000    4.501  0.000  2.94 0.0']);
fprintf(fid,'%s\n',['LAYER   ' num2str(d+6.2,'%1.2f') '  8.000 0.020    4.558  0.011  3.00 0.0']);

fprintf(fid,'%s\n','# Grid2Time');
fprintf(fid,'%s\n','#GTFILES  /Users/karl/Documents/NLLOC/JC114/SG1D/TTimesFrom1DVelmods/velmod  /Users/karl/Documents/NLLOC/JC114/SG1D/TTimesFrom1DVelmods/ttimes P');
fprintf(fid,'%s\n','GTFILES  /Users/karl/Documents/NLLOC/JC114/SG1D/TTimesFrom1DVelmods/velmod  /Users/karl/Documents/NLLOC/JC114/SG1D/TTimesFrom1DVelmods/ttimes S');

fprintf(fid,'%s\n','GTMODE GRID2D ANGLES_YES');

fprintf(fid,'%s\n','# Station:');

fprintf(fid,'%s\n','# Podvin & Lecomte FD params');
fprintf(fid,'%s\n','GT_PLFD  1.0e-3  0');

fclose(fid);
