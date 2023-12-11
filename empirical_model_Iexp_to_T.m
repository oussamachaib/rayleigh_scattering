%% Resetting console

close all
clc
clear

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

plot(I_sim,T,'o','MarkerSize',10);
hold on;
plot(I_sim,fit1,'k','LineWidth',3);
ylabel("$T(\zeta)$ [K]",'Interpreter','latex','FontSize',20);
xlabel("$\hat{I}_{sim} = \left(\frac{\sigma_{eff,ref}}{\sigma_{eff}(\zeta)}\right) \left(\frac{T(\zeta)}{T_{R,ref}} \right)$ [-]",'Interpreter','latex','FontSize',20);
%ylim([0.7 1.2]);

set(gca,'TickLabelInterpreter','latex','FontSize',20);
box on;
grid on;
ax = gca;
axis on;
ax.LineWidth = 2;
ax.GridColor = [0 0 1];
% title('exp2','Interpreter','latex','FontSize',30);
set(gca,'TickLabelInterpreter','latex','FontSize',30);
set(gcf,'OuterPosition',[500 500 500 500]);
legend('Simulation','Model','Interpreter','latex','Location','southeast');
ylim([0 2000]);
xlim([0 10]);

%% Saving

% saveas(gcf,"figures/Isim_T_model_exp2.png");
% saveas(gcf,"figures/Isim_T_model_exp2.fig");


%% Loading experimental data
%% Experimental ratio

% Background scattering (predicted)
I_bs_mean = 0.*ones(size(I_b_mean));

%%% Raw
I_exp = (I_Rref_mean - I_b_mean - I_bs_mean)./(I_R_mean - I_b_mean - I_chem_mean - I_bs_mean);

%%% Filtered
for ifilt = 1:20
    I_exp_filt = medfilt2(I_exp,[3 3]);
end
% Bilateral filter
I_exp_filt = imbilatfilt(I_exp_filt,500,10);
% Anisotropic diffusion (N>=50 preferred)
I_exp_filt = imdiffusefilt(I_exp_filt,'ConductionMethod','quadratic','NumberOfIterations',50);

% I_exp(1:500,:) = 0;
% I_exp(1900:end,:) = 0;
% I_exp_filt(1:500,:) = 0;
% I_exp_filt(1900:end,:) = 0;

T_field = polyval(model,I_exp_filt);

ED = bwperim(imbinarize(T_field.*(T_field<max(T(:)))));
[y,x] = find(ED);

caxis_lim = [300 max(T(:))];
% caxis_lim = [300 2300];

figure();
%imshow(T_field,'InitialMagnification','fit');
imshow(T_field,'InitialMagnification','fit');
hold on;
plot(x,y,'w.','MarkerSize',5);
colormap(turbo);
colorbar();
set(gcf,'OuterPosition',[500 500 500 500]);
title('$T_{exp}$ [K]','FontSize',20,'Interpreter','latex');
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

set(gcf,'OuterPosition',[500 500 500 500]);

%% Saving

% saveas(gcf,"figures/T_exp2.png");
% saveas(gcf,"figures/T_exp2.fig");

% saveas(gcf,"figures/T_exp1_2300K.png");
% saveas(gcf,"figures/T_exp1_2300K.fig");

% saveas(gcf,"figures/T_exp1_superadiab.png");
% saveas(gcf,"figures/T_exp1_superadiab.fig");






