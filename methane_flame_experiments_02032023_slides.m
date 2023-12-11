%% Resetting console
close all
clc
clear

%% Reading image data from .mat file

load 02032023/exp1.mat

%% Reading one instantaneous image

k = 1;
% X = 1;
%path = "/Volumes/TOSHIBA EXT/CambridgeExperiments/H2 project/experiments/02_03_2023_Zyla5p5/rolling shutter/flame_310mJ_X"+string(X)+".tif";
path = "/Volumes/TOSHIBA EXT/CambridgeExperiments/H2 project/experiments/02_03_2023_Zyla5p5/rolling shutter/flame_310mJ.tif";
N = length(imfinfo(path));
I_R_instant = imread(path,k);

% im(I_R_instant); caxis([0 3000]);
%I_R_mean = double(I_R_instant);

%% Plotting average images

figure();
t = tiledlayout(2,3);
t.Padding = 'tight';
%t.TileSpacing = 'none';
caxis_lim = [0 3000];

nexttile();
imshow(I_b_mean);
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
xlim([500 2300]);
ylim([500 1900]);

nexttile();
imshow(I_chem_mean);
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
xlim([500 2300]);
ylim([500 1900]);

nexttile();
imshow(I_Rref_mean);
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
xlim([500 2300]);
ylim([500 1900]);

nexttile();
imshow(I_R_mean);
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
xlim([500 2300]);
ylim([500 1900]);

% saveas(gcf,"figures/CH4_exp_I.png");
% saveas(gcf,"figures/CH4_exp_I.fig");

set(gcf,'OuterPosition',[500 500 1000 400]);

%% Filtering dusty air

for ifilt = 1:20
    I_Rref_mean_filt = medfilt2(I_Rref_mean,[3 3]);
end
I_Rref_mean_filt = imdiffusefilt(I_Rref_mean_filt,'ConductionMethod','quadratic','NumberOfIterations',50);


%% Plotting filtered ratio

% Background scattering (predicted)
I_bs_mean = 0.*ones(size(I_b_mean));

%%% Raw
I_exp = (I_Rref_mean - I_b_mean - I_bs_mean)./(I_R_mean - I_b_mean - I_chem_mean - I_bs_mean);

%%% Filtered
for ifilt = 1:20
    I_exp_filt = medfilt2(I_exp,[3 3]);
end
% Bilateral filter
% I_exp_filt = imbilatfilt(I_exp_filt,500,10);
% Anisotropic diffusion (N>=50 preferred)
I_exp_filt = imdiffusefilt(I_exp_filt,'ConductionMethod','quadratic','NumberOfIterations',50);

caxis_lim = [0 10];

I_exp(1:500,:) = 0;
I_exp(1900:end,:) = 0;
I_exp_filt(1:500,:) = 0;
I_exp_filt(1900:end,:) = 0;


nexttile();
imshow(I_exp);
colormap(BWR2(1000));
colorbar();
set(gcf,'OuterPosition',[500 500 500 500]);
title('$\hat{I}_{exp}$','FontSize',20,'Interpreter','latex');
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
% xlim([500 2000]);
xlim([500 2300]);
ylim([500 1900]);

nexttile();
imshow(I_exp_filt);
colormap(BWR2(1000));
colorbar();
set(gcf,'OuterPosition',[500 500 500 500]);
title('$\hat{I}_{exp,f}$','FontSize',20,'Interpreter','latex');
% hold on;
% plot(X,Y,'.w','MarkerSize',5);ss
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
xlim([500 2300]);
ylim([500 1900]);

set(gcf,'OuterPosition',[500 500 800 500]);

%% Saving

% saveas(gcf,"figures/exp1.png");
% saveas(gcf,"figures/exp1.fig");




