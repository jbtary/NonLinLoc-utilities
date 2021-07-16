% Read and write the velocity models provided by R. Hobbs for NNLOC
% First, case of the velocity model of NG (then SG down below)

clear
file = '/Users/jeanbaptistetary/Documents/JC114/vel5.dms';
fid=fopen(file,'r');
while ~feof(fid)
  tmp = fread(fid,'uint32');
end
fclose(fid);

%% Reshape the velocity model

% Characs of model
nx = 601; % Number of nodes in the x direction
ny = 601; % Number of nodes in the y direction
nz = 121; % Number of nodes in the z direction
dc = 0.1; % Spacing between nodes in km

iv = find(tmp == 2404); % Identify 2404 values to remove them (4 bytes header and trailer of Fortran file)
dif = length(tmp) - length(iv);
if dif ~= nx*ny*nz; disp('Some 2404 values must correspond to vel values'); end
tmp2 = tmp; tmp2(iv) = [];

% Make a cube
vel = reshape(tmp2,[nx ny nz]);

%% Plot a slice of the cube of the velocity model
figure
axes('position',[.1 .5 .5 .4]); % Pos minx miny sizex sizey, Hz slice
imagesc(0:dc:(nx-1)*dc,0:dc:(ny-1)*dc,squeeze(vel(:,:,51))')
colormap(jet); colorbar; caxis([2200 7400])
ylabel('y, toward South (km)')
title('Slices of the velocity model, in m/s')
% This axis direction seems alright (checked with Robinson paper)
% Add the OBS locations
obs = load('obslocs.txt'); 
[utmx,utmy] = deg2utm([obs(:,1);3.0436111],[obs(:,2);-84]);
utmx = utmx - utmx(end); utmy = utmy - utmy(end);
utmx(utmy<1) = []; utmy(utmy<1) = [];
hold on; plot(utmx/1000,(60 - (utmy/1000)),'sk','MarkerFaceColor','w')
% Max approx. 200 m between bathymetry and depth of OBSs
% This is a difference of time max of approx. 200/(3500 - 1500) = 0.1 s.

axes('position',[.1 .15 .5 .3]); % West-East cross-section
imagesc(0:dc:(nx-1)*dc,0:dc:(nz-1)*dc,squeeze(vel(:,527,:))')
colorbar;
xlabel('x, toward East (km)'); ylabel('z (km)')
% This axis direction seems alright (checked with Robinson paper)

axes('position',[.65 .5 .25 .4]); % North-South cross-section
imagesc(0:dc:(nz-1)*dc,0:dc:(nx-1)*dc,squeeze(vel(301,:,:)))
colorbar;
xlabel('z (km)')
% This axis direction seems alright (checked with Robinson paper)

%% Write the velocity model to file for NLLOC

% hdr file with grid params
pathf1 = 'velmod3D_JC114.hdr';
% grid file with values
pathf2 = 'velmod3D_JC114.buf';

% Reshape the velocity model, looping first on z, then y, then x
n = 1;
for ii = 1:nx % x direction toward East: ok
    for jj = ny:-1:1 % y direction toward South: have to reverse it
        for kk = 1:nz % z direction down: ok
            veltmp(n,1) = vel(ii,jj,kk);
            n = n + 1;
        end
    end
end

% Write to file: hdr file (ASCII)
fid = fopen(pathf1,'w');
fprintf(fid,'%s',[num2str(nx,'%d') ' ' num2str(ny,'%d') ' ' num2str(nz,'%d') ' ' ...
    num2str(0,'%3.6f') ' ' num2str(0,'%3.6f') ' ' num2str(0,'%3.6f') ' ' ...
    num2str(dc,'%1.2f') ' ' num2str(dc,'%1.2f') ' ' num2str(dc,'%1.2f') ' SLOW_LEN']);
fclose(fid);

% Convert velocity model in m/s to slowness in s/km *length for NLLOC
veltmp = (1./(veltmp/1000))*dc;

% Write to file: binary grid file (velocity in km/s)
fid = fopen(pathf2,'w');
fwrite(fid,veltmp,'float');
fclose(fid);

%% Read the velocity model provided by R. Hobbs for JC114 SG
clear
% file = '/Volumes/HDTary1/JC114/VelocityModelSG/vel3';
file = '/media/usuario/HDTary1/JC114/VelocityModelSG/vel3';
fid=fopen(file,'r');
while ~feof(fid)
  tmp = fread(fid,'uint32');
end
fclose(fid);

% Reshape the velocity model
% Characs of model
nx = 601; % Number of nodes in the x direction
ny = 601; % Number of nodes in the y direction
nz = 151; % Number of nodes in the z direction
dc = 0.1; % Spacing between nodes in km

iv = find(tmp == 2404); % Identify 2404 values to remove them (4 bytes header and trailer of Fortran file)
dif = length(tmp) - length(iv);
if dif ~= nx*ny*nz; disp('Some 2404 values must correspond to vel values'); end
tmp2 = tmp; tmp2(iv) = [];

% Make a cube
vel = reshape(tmp2,[nx ny nz]);

%% Plot a slice of the SG cube of the velocity model
figure
axes('position',[.1 .5 .5 .4]); % Pos minx miny sizex sizey, Hz slice
imagesc(0:dc:(nx-1)*dc,0:dc:(ny-1)*dc,squeeze(vel(:,:,48))')
colormap(jet); colorbar; caxis([2200 7400])
ylabel('y, toward South (km)')
title('Slices of the velocity model, in m/s')
% This axis direction seems alright (checked with Gregory paper)

axes('position',[.1 .15 .5 .3]); % West-East cross-section
imagesc(0:dc:(nx-1)*dc,0:dc:(nz-1)*dc,squeeze(vel(:,318,:))')
colorbar;
xlabel('x, toward East (km)'); ylabel('z (km)')
% This axis direction seems alright (checked with Gregory paper)

axes('position',[.65 .5 .25 .4]); % North-South cross-section
imagesc(0:dc:(nz-1)*dc,0:dc:(nx-1)*dc,squeeze(vel(301,:,:)))
colorbar;
xlabel('z (km)')
% This axis direction seems alright (checked with Gregory paper)

%% Write the velocity model to file for NLLOC

% hdr file with grid params
pathf1 = 'velmod3D_JC114_SG.hdr';
% grid file with values
pathf2 = 'velmod3D_JC114_SG.buf';

% Limit the model to the well resolved part (according to E. Gregory): 
% from 15 to 45 km in X and Y (and from 0 to 6 km in Z, ignored for Z,
% still better than 1D)
vel2 = vel(151:451,151:451,:);
nx2 = size(vel2,1); ny2 = size(vel2,2); nz2 = size(vel2,3);

% Reshape the velocity model, looping first on z, then y, then x
n = 1;
for ii = 1:nx2 % x direction toward East: ok
    for jj = ny2:-1:1 % y direction toward South: have to reverse it
        for kk = 1:nz2 % z direction down: ok
            veltmp(n,1) = vel2(ii,jj,kk);
            n = n + 1;
        end
    end
end

% Write to file: hdr file (ASCII)
fid = fopen(pathf1,'w');
fprintf(fid,'%s',[num2str(nx2,'%d') ' ' num2str(ny2,'%d') ' ' num2str(nz2,'%d') ' ' ...
    num2str(0,'%3.6f') ' ' num2str(0,'%3.6f') ' ' num2str(0,'%3.6f') ' ' ...
    num2str(dc,'%1.2f') ' ' num2str(dc,'%1.2f') ' ' num2str(dc,'%1.2f') ' SLOW_LEN']);
fclose(fid);

% Convert velocity model in m/s to slowness in s/km *length for NLLOC
veltmp = (1./(veltmp/1000))*dc;

% Write to file: binary grid file (velocity in km/s)
fid = fopen(pathf2,'w');
fwrite(fid,veltmp,'float');
fclose(fid);

%% Write the velocity model to file for NLLOC - S-wave velocity model

% hdr file with grid params
pathf1 = 'velmod3D_JC114_SG_S.hdr';
% grid file with values
pathf2 = 'velmod3D_JC114_SG_S.buf';

% Limit the model to the well resolved part (according to E. Gregory): 
% from 15 to 45 km in X and Y (and from 0 to 6 km in Z, ignored for Z,
% still better than 1D)
vel2 = vel(151:451,151:451,:);
nx2 = size(vel2,1); ny2 = size(vel2,2); nz2 = size(vel2,3);

% Set the velocities of the water to 0
vel2(vel2 < 1550) = 0;
% 'Convert' to a S-wave velocity model with the Vp/Vs ratio
vel2 = vel2/1.76; vel2(vel2 == 0) = 0.001; % No 0 values...

% Reshape the velocity model, looping first on z, then y, then x
n = 1;
for ii = 1:nx2 % x direction toward East: ok
    for jj = ny2:-1:1 % y direction toward South: have to reverse it
        for kk = 1:nz2 % z direction down: ok
            veltmp(n,1) = vel2(ii,jj,kk);
            n = n + 1;
        end
    end
end

% Write to file: hdr file (ASCII)
fid = fopen(pathf1,'w');
fprintf(fid,'%s',[num2str(nx2,'%d') ' ' num2str(ny2,'%d') ' ' num2str(nz2,'%d') ' ' ...
    num2str(0,'%3.6f') ' ' num2str(0,'%3.6f') ' ' num2str(0,'%3.6f') ' ' ...
    num2str(dc,'%1.2f') ' ' num2str(dc,'%1.2f') ' ' num2str(dc,'%1.2f') ' SLOW_LEN']);
fclose(fid);

% Convert velocity model in m/s to slowness in s/km *length for NLLOC
veltmp = (1./(veltmp/1000))*dc;

% Write to file: binary grid file (velocity in km/s)
fid = fopen(pathf2,'w');
fwrite(fid,veltmp,'float');
fclose(fid);
