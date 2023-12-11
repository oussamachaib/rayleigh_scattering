%% Resetting console

close all
clc
clear

%% Loading simulation data

load simulation/0h2_1.83phi_sim.mat

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
I_sim = (sigma_eff./sigma_eff_air).*(300./T);

% Fitting polynomial
model = polyfit(1./I_sim,T,5);
fit1 = polyval(model,1./I_sim);

plot(I_sim,T,'o','MarkerSize',10);
hold on;
plot(I_sim,fit1,'k','LineWidth',3);
ylabel("$T$ [K]",'Interpreter','latex','FontSize',20);
xlabel("$\hat{I}_{sim} = \left(\frac{\sigma_{eff}}{\sigma_{eff,ref}}\right) \left(\frac{T_{R,ref}}{T_{R}} \right)$ [-]",'Interpreter','latex','FontSize',20);
%ylim([0.7 1.2]);

set(gca,'TickLabelInterpreter','latex','FontSize',20);
box on;
grid on;
ax = gca;
axis on;
ax.LineWidth = 2;
ax.GridColor = [0 0 1];
% title('exp2','Interpreter','latex','FontSize',30);
l.Interpreter = 'latex';
l.Location = 'southeast';
set(gca,'TickLabelInterpreter','latex','FontSize',30);
set(gcf,'OuterPosition',[500 500 500 500]);
legend('Simulation','Model','Interpreter','latex');
ylim([0 2000]);
xlim([0 1.5]);

%% Saving

% saveas(gcf,"figures/Isim_T_model_exp1.png");
% saveas(gcf,"figures/Isim_T_model_exp1.fig");


%% Loading experimental data

load 02032023/exp1.mat

%% Experimental ratio

I_exp = (I_Rref_mean - I_b_mean)./(I_R_mean-I_b_mean-I_chem_mean);
I_exp_filt = I_exp;%imgaussfilt(I_exp,20);

%% Temperature field

T_field = polyval(model,I_exp_filt);
% T_field(T_field<300) = 0;

% im(T_field);
% colormap(BWR2(1000));
% caxis([300 1300]);












