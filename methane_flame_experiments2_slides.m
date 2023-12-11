%% Resetting console
close all
clc
clear

%% Reading image file
% Reading .tif extensions

% Background : Air + Laser off
path = "/Users/oussamachaib/Desktop/Experiments/experiments/28_02_2023_Zyla5p5/bg_1mJ.tif";
N = length(imfinfo(path));
I_b = zeros(2160,2560);

for k = 1:N
disp("Reading background (L:OFF) image "+string(k)+"/"+string(N)+"...");
I_temp = imread(path,k);
I_b = I_b + double(I_temp);
% im(I_temp);
% caxis([300 1200]);
end

% Non-reacting : Air + Methane
path = "/Users/oussamachaib/Desktop/Experiments/experiments/28_02_2023_Zyla5p5/air_methane_nonreac_310mJ.tif";
N = length(imfinfo(path));
I_nonreac = zeros(2160,2560);

for k = 1:N
disp("Reading non-reacting fuel/air (L:ON) image "+string(k)+"/"+string(N)+"...");
I_temp = imread(path,k);
I_nonreac = I_nonreac + double(I_temp);
% im(I_temp);
% caxis([300 1200]);
end

% Chemiluminescence
path = "/Users/oussamachaib/Desktop/Experiments/experiments/28_02_2023_Zyla5p5/chem_1mJ.tif";
N = length(imfinfo(path));
I_chem = zeros(2160,2560);

for k = 1:N
disp("Reading chemiluminescence (L:OFF) image "+string(k)+"/"+string(N)+"...");
I_temp = imread(path,k);
I_chem = I_chem + double(I_temp);
% im(I_temp);
% caxis([300 1200]);
end


% Reference : Air
path = "/Users/oussamachaib/Desktop/Experiments/experiments/28_02_2023_Zyla5p5/air_310mJ.tif";
N = length(imfinfo(path));
I_air = zeros(2160,2560);

for k = 1:N
disp("Reading air (L:ON) image "+string(k)+"/"+string(N)+"...");
I_temp = imread(path,k);
I_air = I_air + double(I_temp);
% im(I_temp);
% caxis([300 1200]);
end

% Measurement : Flame

path = "/Users/oussamachaib/Desktop/Experiments/experiments/28_02_2023_Zyla5p5/flame_310mJ.tif";
path1 = "/Users/oussamachaib/Desktop/Experiments/experiments/28_02_2023_Zyla5p5/flame_310mJ_1.tif";
%path2 = "/Users/oussamachaib/Desktop/Experiments/experiments/28_02_2023_Zyla5p5/flame_310mJ_2.tif";

I_flame = zeros(2160,2560);
for k = 1:N
disp("Reading flame (L:ON) image "+string(k)+"/"+string(N)+"...");
I_temp = imread(path,k);
I_flame = I_flame + double(I_temp);
I_temp = imread(path1,k);
I_flame = I_flame + double(I_temp);
% I_temp = imread(path2,k);
% I_flame = I_flame + double(I_temp);
% im(I_temp);
% caxis([300 1200]);
end

%% Averaging

I_chem = I_chem./N;
I_b = I_b./N;
I_air = I_air./N;
I_flame = I_flame./(2.*N);
I_nonreac = I_nonreac./N;

%% Vertical laser profile

V = smoothdata(mean(I_air,2),'movmean',200);
V = V./max(V(:));

Vgrid = zeros(size(I_air));

for i = 1:size(I_air,2)
Vgrid(:,i) = V;
end

%% Plotting average images

figure();
t = tiledlayout(1,4);
t.Padding = 'tight';
%t.TileSpacing = 'none';
caxis_lim = [0 3000];

% nexttile();
% imshow(I_nonreac);
% colormap(BWR2(1000));
% c = colorbar();
% c.TickLabelInterpreter = 'latex';
% c.Ticks = [0 1500];
% caxis([0 1500]);
% c.Box = "on";
% c.LineWidth = 4;
% title('$I_{CH_4/air,nr}$','FontSize',20,'Interpreter','latex');
% set(gca,'TickLabelInterpreter','latex','FontSize',30,'YTickLabel',"",'XTickLabel',"");
% box on;
% ax = gca;
% axis on;
% ax.LineWidth = 4;

nexttile();
imshow(I_b);
colormap(BWR2(1000));
c = colorbar();
c.TickLabelInterpreter = 'latex';
c.Ticks = caxis_lim./2;
caxis(caxis_lim./2);
c.Box = "on";
c.LineWidth = 4;
title('$I_{dc}$','FontSize',20,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','FontSize',30,'YTickLabel',"",'XTickLabel',"");
box on;
ax = gca;
axis on;
ax.LineWidth = 4;

nexttile();
imshow(I_chem);
colormap(BWR2(1000));
c = colorbar();
c.TickLabelInterpreter = 'latex';
c.Ticks = caxis_lim;
caxis(caxis_lim);
c.Box = "on";
c.LineWidth = 4;
title('$I_{chem}$','FontSize',20,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','FontSize',30,'YTickLabel',"",'XTickLabel',"");
box on;
ax = gca;
axis on;
ax.LineWidth = 4;

nexttile();
imshow(I_air);
colormap(BWR2(1000));
c = colorbar();
c.TickLabelInterpreter = 'latex';
c.Ticks = [0 3000];
caxis([0 3000]);c.Box = "on";
c.LineWidth = 4;
title('$I_{R,ref}$','FontSize',20,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','FontSize',30,'YTickLabel',"",'XTickLabel',"");
box on;
ax = gca;
axis on;
ax.LineWidth = 4;

nexttile();
imshow(I_flame);
colormap(BWR2(1000));
c = colorbar();
c.TickLabelInterpreter = 'latex';
c.Ticks = caxis_lim;
caxis(caxis_lim);
c.Box = "on";
c.LineWidth = 4;
title('$I_{R}$','FontSize',20,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','FontSize',30,'YTickLabel',"",'XTickLabel',"");
box on;
ax = gca;
axis on;
ax.LineWidth = 4;

% saveas(gcf,"figures/CH4_exp_I.png");
% saveas(gcf,"figures/CH4_exp_I.fig");

set(gcf,'OuterPosition',[500 500 1000 400]);

%% Plotting ratio

I_R = I_flame - I_chem - I_b;
I_Rref = I_air - I_b;
I_Rnonreac = I_nonreac - I_b;

T0 = 300;
R = (I_Rref./I_R);
%R = I_R./I_Rref;


%% Filtering ratio

for ifilt = 1:20
    Rf = medfilt2(R,[3 3]);
end
Rf = imdiffusefilt(Rf,'ConductionMethod','quadratic','NumberOfIterations',80);

%% Removing dust
Rf_temp = Rf + zeros(size(Rf));
Rbin = imbinarize(R,1);
% % % Rbin_temp = Rbin + zeros(size(Rbin));
% % % % Finding connected components in the temporary binary image
% % % Z = bwconncomp(Rbin_temp);
% % % % Counting the number of elements in each connected components
% % % numPixels = cellfun(@numel,Z.PixelIdxList);
% % % % Finding the index of the largest object within the binary image
% % % [~,idx] = max(numPixels);
% % % % Discarding all objects but the largest one in the binary image
% % % for ibw = 1:Z.NumObjects
% % %     if ibw ~= idx
% % %         Rbin_temp(Z.PixelIdxList{ibw}) = 0;
% % %     end
% % % end
% % % 
% % % % Dust speckles in background
% % % bg_speckles = Rbin-Rbin_temp;
% % % % Dust speckles in jet
% % % jet_speckles = imfill(Rbin_temp,'holes') - Rbin_temp;
% % % 
% % % 
% % % % Rf_temp(find(bg_speckles)) = .5;
% % % % Rf_temp(find(jet_speckles)) = .5;
% % % 
% % % %% Jet edge
% % % ED = (bwperim(imfill(Rbin_temp,'holes')));
% % % [Y,X] = find(ED);

%% Plotting filtered ratio
caxis_lim = [0 10];

figure();
t = tiledlayout(1,2);
nexttile();
imshow(R);
colormap(BWR2(1000));
colorbar();
set(gcf,'OuterPosition',[500 500 500 500]);
title('$\frac{I_{R,ref}-I_{dc}}{I_{R}-I_{chem}-I_{dc}}$','FontSize',20,'Interpreter','latex');
% hold on;
% plot(X,Y,'.w','MarkerSize',5);
caxis(caxis_lim);
box on;
ax = gca;
axis on;
ax.LineWidth = 4;
c = colorbar();
c.TickLabelInterpreter = 'latex';
c.Ticks = caxis_lim;
c.Box = "on";
c.LineWidth = 4;
set(gca,'TickLabelInterpreter','latex','FontSize',30,'YTickLabel',"",'XTickLabel',"");
% xlim([650 2050]);
ylim([500 1900]);

nexttile();
imshow(Rf);
colormap(BWR2(1000));
colorbar();
set(gcf,'OuterPosition',[500 500 500 500]);
title('Filtered','FontSize',20,'Interpreter','latex');
% hold on;
% plot(X,Y,'.w','MarkerSize',5);
caxis(caxis_lim);
box on;
ax = gca;
axis on;
ax.LineWidth = 4;
c = colorbar();
c.TickLabelInterpreter = 'latex';
c.Ticks = caxis_lim;
c.Box = "on";
c.LineWidth = 4;
set(gca,'TickLabelInterpreter','latex','FontSize',30,'YTickLabel',"",'XTickLabel',"");
% xlim([650 2050]);
ylim([500 1900]);

saveas(gcf,"figures/CH4_exp_r.png");
saveas(gcf,"figures/CH4_exp_r.fig");

set(gcf,'OuterPosition',[500 500 800 500]);

%% SNR (raw and filtered image)

jet_raw = R.*Rbin.*(R<2);
bg_raw = R.*(1-Rbin).*(R<2);

jet_filtered = Rf.*Rbin.*(R<2);
bg_filtered = Rf.*(1-Rbin).*(R<2);

% SNR_raw = (mean(jet_raw(jet_raw>0)) - mean(bg_raw(bg_raw>0)))./std(jet_raw(jet_raw>0))
% SNR_filtered = (mean(jet_filtered(jet_filtered>0)) - mean(bg_filtered(bg_filtered>0)))./std(jet_filtered(jet_filtered>0))

SNR_raw = mean(jet_raw(jet_raw>0))./std(jet_raw(jet_raw>0))
SNR_filtered = mean(jet_filtered(jet_filtered>0))./std(jet_filtered(jet_filtered>0))



