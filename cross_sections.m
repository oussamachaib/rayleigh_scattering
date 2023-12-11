%% Resetting console

close all
clc
clear

%% Loading simulation data

%load simulation/100h2_0.7phi_sim.mat
load simulation/0h2_0.7phi_sim.mat

%% Plotting molar fractions of species

c_T = (T-T(1))./(T(end)-T(1));
figure();
plot(Lx,Xi);
legend(species);
ylabel("$X_i$ [-]",'Interpreter','latex','FontSize',20);
xlabel("$x$ [m]",'Interpreter','latex','FontSize',20);

%% Plotting mass fractions of species

figure();
plot(Lx,Yi);
legend(species);
ylabel("$Y_i$ [-]",'Interpreter','latex','FontSize',20);
xlabel("$x$ [m]",'Interpreter','latex','FontSize',20);

%% Plotting species cross sections

figure();
plot(Lx,Xi.*sigma_species')
legend(species);
ylabel("$X_i\sigma_i$ [-]",'Interpreter','latex','FontSize',20);
xlabel("$x$ [m]",'Interpreter','latex','FontSize',20);

%% Plotting effective cross section
% Important : cross-sections are written as fractions of sigma_N2
% https://www.engineeringtoolbox.com/air-composition-d_212.html
% Flame sigma_eff
sigma_eff = (Xi.*sigma_species');
sigma_eff = sum(sigma_eff,1)./sum(Xi,1);

% Air sigma_eff
X_i_air = [.78084, .20946, 0.00934, 0.000412]; % N2, O2, Ar, CO2
sigma_species_air = [1, .859, .865, 2.427];
sigma_eff_air = (X_i_air).*sigma_species_air;
sigma_eff_air = sum(sigma_eff_air)./(sum(X_i_air));


figure();
% plot(Lx,c_T);
% hold on;
plot(Lx,sigma_eff./sigma_eff_air);
ylabel("$\sigma_{eff}/\sigma_{eff,air}$ [-]",'Interpreter','latex','FontSize',20);
xlabel("$x$ [m]",'Interpreter','latex','FontSize',20);
ylim([0.5 1.5]);







