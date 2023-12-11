%% Resetting console
close all
clc
clear

%% Reading mean data

%% Loading simulation data

load simulation/0h2_1.83phi_sim.mat
load 02032023/exp1.mat

% load simulation/0h2_2.5phi_sim.mat
% load 02032023/exp2.mat

%% Empirical Cantera model

% Air sigma_eff
X_i_air = [.78084, .20946, 0.00934, 0.000412]; % N2, O2, Ar, CO2
sigma_species_air = [1, .859, .865, 2.427];
sigma_eff_air = (X_i_air).*sigma_species_air;
sigma_eff_air = sum(sigma_eff_air)./(sum(X_i_air));
% Flame sigma_eff
sigma_eff = (Xi.*sigma_species');
sigma_eff = sum(sigma_eff,1)./sum(Xi,1);
c_T = (T-T(1))./(T(end)-T(1));
%I_sim = (sigma_eff./sigma_eff_air).*(300./T);
I_sim = (sigma_eff_air./sigma_eff).*(T./300);


% Fitting polynomial
model = polyfit(I_sim,T,2);
fit1 = polyval(model,I_sim);

%% Flame (N = 1000)

% Recording movie

v2 = VideoWriter('videos/exp1_temp.mp4','MPEG-4');
v2.FrameRate = 10;
v2.Quality = 100;

% open(v2);


% Flame
cnt = 0;
I_R = zeros(2160,2560);

% Figure details
figure();
set(gcf,'OuterPosition',[500 500 500 500]);

for X = 0:1:5
% tif image batch
if X == 0
    path = "/Volumes/TOSHIBA EXT/CambridgeExperiments/H2 project/experiments/02_03_2023_Zyla5p5/flame_310mJ.tif";
else
    path = "/Volumes/TOSHIBA EXT/CambridgeExperiments/H2 project/experiments/02_03_2023_Zyla5p5/flame_310mJ_X"+string(X)+".tif";
end
N = length(imfinfo(path));

% images within each batch
    for k = 1:N
        cnt = cnt+1;
        disp("Reading flame image "+string(k)+"/"+string(N)+"...");
        I_temp = imread(path,k);
        I_R = double(I_temp);
        % Background scattering (predicted)
        I_bs_mean = 0.*ones(size(I_b_mean));   
        %%% Raw
        I_exp = (I_Rref_mean - I_b_mean - I_bs_mean)./(I_R - I_b_mean - I_chem_mean - I_bs_mean);   
%         %%% Filtered
%         for ifilt = 1:20
%             I_exp_filt = medfilt2(I_exp,[3 3]);
%         end
%         % Bilateral filter
%         I_exp_filt = imbilatfilt(I_exp_filt,500,10);
%         % Anisotropic diffusion (N>=50 preferred)
        %I_exp_filt = imdiffusefilt(I_exp_filt,'ConductionMethod','quadratic','NumberOfIterations',10);     
        T_field = polyval(model,I_exp);
        T_field(T_field<300) = 300;
        %ED = bwperim(imbinarize(T_field.*(T_field<max(T(:)))));
        %[y,x] = find(ED);
        imshow(T_field,'InitialMagnification','fit');
        %hold on;
        %plot(x,y,'w.','MarkerSize',5);
        caxis_lim = [300 round(max(T(:)))];  
        colormap(turbo);
        colorbar();
        set(gcf,'OuterPosition',[500 500 800 800]);
        title('$T_{exp}$ [K]','FontSize',20,'Interpreter','latex');
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
        text(520,570,'i = '+string(cnt)+'/1000','Color','w','FontSize',25,'Interpreter','latex');
        drawnow;
        frame = getframe(gcf);
        writeVideo(v2,frame);
    end
end

close(v2);
