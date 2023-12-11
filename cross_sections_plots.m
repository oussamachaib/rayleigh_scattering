%% Resetting console

%close all
clc
clear

%% Loading simulation data

load simulation/100h2_0.5phi_sim.mat
%load simulation/50h2_1phi_sim.mat
%load simulation/70h2_1phi_sim.mat
%load simulation/0h2_0.5phi_sim.mat

%% Plotting molar fractions of species

c_T = (T-T(1))./(T(end)-T(1));
figure();
t = tiledlayout(1,3);
t.Padding = 'tight';

t.Layout
nexttile(t,1);
plot(Lx,Xi,'LineWidth',2);
hold on;
plot(Lx,c_T,'k:','LineWidth',2);
ylabel("$X_i$ [-]",'Interpreter','latex','FontSize',20);
xlabel("$x$ [m]",'Interpreter','latex','FontSize',20);
set(gca,'TickLabelInterpreter','latex','FontSize',20);
box on;
grid on;
ax = gca;
axis on;
ax.LineWidth = 2;
ax.GridColor = [0 0 1];

l = legend(species);
l.Layout.Tile = 'east';
l.FontSize = 10;
%% Plotting species cross sections
% Air sigma_eff
X_i_air = [.78084, .20946, 0.00934, 0.000412]; % N2, O2, Ar, CO2
sigma_species_air = [1, .859, .865, 2.427];
sigma_eff_air = (X_i_air).*sigma_species_air;
sigma_eff_air = sum(sigma_eff_air)./(sum(X_i_air));

nexttile(t,2);
plot(Lx,Xi.*sigma_species'./sigma_eff_air,'LineWidth',2);
ylabel("$X_i\sigma_i/\sigma_{eff,air}$ [-]",'Interpreter','latex','FontSize',20);
xlabel("$x$ [m]",'Interpreter','latex','FontSize',20);
set(gca,'TickLabelInterpreter','latex','FontSize',20);
box on;
grid on;
ax = gca;
axis on;
ax.LineWidth = 2;
ax.GridColor = [0 0 1];

%% Plotting effective cross section
% Important : cross-sections are written as fractions of sigma_N2
% https://www.engineeringtoolbox.com/air-composition-d_212.html

% Flame sigma_eff
sigma_eff = (Xi.*sigma_species');
sigma_eff = sum(sigma_eff,1)./sum(Xi,1);



nexttile(t,3);
plot(Lx,sigma_eff./sigma_eff_air,':k','LineWidth',2);
ylabel("$\sigma_{eff}/\sigma_{eff,air}$ [-]",'Interpreter','latex','FontSize',20);
xlabel("$x$ [m]",'Interpreter','latex','FontSize',20);
ylim([0.7 1.1]);
set(gca,'TickLabelInterpreter','latex','FontSize',20);
box on;
grid on;
ax = gca;
axis on;
ax.LineWidth = 2;
ax.GridColor = [0 0 1];

set(gcf,'OuterPosition',[500 500 1200 400]);

%% Saving

% saveas(gcf,"figures/100h2_0.5phi_sim.png");
% saveas(gcf,"figures/100h2_0.5phi_sim.fig");



