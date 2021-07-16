% Function to plot the total pdf and the hypocenters obtained with
% NonLinLoc (or any pdf of any event converted to the matlab format)
% Possible improvements: implement automatic resampling and interpolation
% to get a smoother plot
% 
% INPUT
%   path1: path and filename to the total pdf to plot (mat file)
%   nx, ny, nz: number of nodes in x, y, and z directions
%   dx, dy, dz: increment in x, y, and z directions
%   These can be obtained from one of the *.octree.hdr file (grid file header)
%   xori, yori, zori: origin of the grid in long, lat and depth (have to be
%   calculated from information in nlloc input file)
%   pos: long, lat, depth position to calculate the sections
%   dist: distance in km around the pos for summation in long, lat and
%   depth directions
%   path2: path and filename of the file with hypocenters
%   plfc: plotting function to use to plot the sections, use either
%   @imagesc or @contourf
% OUTPUT
%   None, just plot the figure
% 
% Example:
% path1 = 'NG1D/loc_pdftot.mat';
% path2 = 'NG1D/'; file = 'LocOutputs.sum.grid0.loc.hyp';
% nx = 700; ny = 700; nz = 31; dx = 2; dy = 2; dz = 2;
% pos = [-83.7694 3.34319 15]; dist = [30 10 15];
% xori = -84 + (-700/(cosd(3.0436111)*110.567));
% yori = 3.0436111 + (-700/110.567);
% zori = 0;

function [mapcs,loncs,latcs,lons,lats,deps,locs] = plotunc(...
    path1,nx,ny,nz,dx,dy,dz,xori,yori,zori,pos,dist,path2,file,plfc)

pdf = load(path1,'pdftot'); % Total pdf
pdf = pdf.pdftot;
pdf2 = reshape(pdf,[nz ny nx]);
pdf2 = permute(pdf2,[3 2 1]); clear pdf

% Coordinates in degrees of the grid
deglon = cosd(yori)*110.567; % Length of a degree in longitude at yori
deglat = 110.567 + ((yori/90) * (111.699-110.567)); % Length of a degree in latitude at yori
lats = yori + (((0:ny-1)*dy)/deglat);
lons = xori + (((0:nx-1)*dx)/deglon);
deps = zori + ((0:nz-1)*dz);

% Indexes for summation
iv2 = find(lats>pos(2)-(dist(2)/deglat) & lats<pos(2)+(dist(2)/deglat));
iv1 = find(lons>pos(1)-(dist(1)/deglon) & lons<pos(1)+(dist(1)/deglon));
iv3 = find(deps>pos(3)-dist(3) & deps<pos(3)+dist(3));

% Sections
loncs = squeeze(sum(pdf2(:,iv2,:),2));
latcs = squeeze(sum(pdf2(iv1,:,:),1));
mapcs = squeeze(sum(pdf2(:,:,iv3),3));

% Selection of events to plot on the sections
locs = nlloc_attributes(path2,file,0,'',0,'');
l1 = find(locs(:,8)>pos(1)-(dist(1)/deglon) & locs(:,8)<pos(1)+(dist(1)/deglon));
l2 = find(locs(:,7)>pos(2)-(dist(2)/deglat) & locs(:,7)<pos(2)+(dist(2)/deglat));
l3 = find(locs(:,9)>pos(3)-dist(3) & locs(:,9)<pos(3)+dist(3));
ll = intersect(l1,l2);
ll = intersect(ll,l3);

% Plotting
figure;
axes('Position', [0.1 0.4 0.5 0.5]) % Map
plfc(lons,lats,log10(mapcs'))
hold on; plot(locs(ll,8),locs(ll,7),'co','MarkerFaceColor','r')
ylabel('Latitude');
axis([pos(1)-(dist(1)/deglon)-0.01 pos(1)+(dist(1)/deglon)+0.01 ...
    pos(2)-(dist(2)/deglat)-0.01 pos(2)+(dist(2)/deglat)+0.01])
if strcmp(func2str(plfc),'contourf')
    legend('PDF','Earthquakes')
else
    set(gca,'YDir','normal'); legend('Earthquakes')
end

axes('Position', [0.1 0.1 0.5 0.25]) % E-W CS
plfc(lons,deps,log10(loncs'))
hold on; plot(locs(ll,8),locs(ll,9),'co','MarkerFaceColor','r')
xlabel('Longitude'); ylabel('Depth (km)');
axis([pos(1)-(dist(1)/deglon)-0.01 pos(1)+(dist(1)/deglon)+0.01 pos(3)-dist(3)-0.1 pos(3)+dist(3)+0.1])
if strcmp(func2str(plfc),'contourf'); set(gca,'YDir','reverse'); end

axes('Position', [0.65 0.4 0.25 0.5]) % S-N CS
plfc(deps,lats,log10(latcs))
hold on; plot(locs(ll,9),locs(ll,7),'co','MarkerFaceColor','r')
xlabel('Depth (km)'); set(gca,'YDir','normal')
axis([pos(3)-dist(3)-0.1 pos(3)+dist(3)+0.1 pos(2)-(dist(2)/deglat)-0.01 pos(2)+(dist(2)/deglat)+0.01])
