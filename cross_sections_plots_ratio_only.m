%% Resetting console

close all
clc
clear

%% Loading simulation data

h2_pc = [0 70 100];
phi_iteration = [0.5,1];

figure();
t = tiledlayout(1,3);
t.Padding = 'tight';

for i_h2 = 1:length(h2_pc)
nexttile();

for i_phi = 1:length(phi_iteration)

load("simulation/"+string(h2_pc(i_h2))+"h2_"+string(phi_iteration(i_phi))+"phi_sim.mat");

%% Plotting species cross sections

% Air sigma_eff
X_i_air = [.78084, .20946, 0.00934, 0.000412]; % N2, O2, Ar, CO2
sigma_species_air = [1, .859, .865, 2.427];
sigma_eff_air = (X_i_air).*sigma_species_air;
sigma_eff_air = sum(sigma_eff_air)./(sum(X_i_air));

% Flame sigma_eff
sigma_eff = (Xi.*sigma_species');
sigma_eff = sum(sigma_eff,1)./sum(Xi,1);

c_T = (T-T(1))./(T(end)-T(1));

plot(c_T,sigma_eff./sigma_eff_air,'LineWidth',2);
% plot(c_T,Xi(1,:),'LineWidth',2);
if h2_pc(i_h2) == 0
ylabel("$\frac{\sigma_{eff}}{\sigma_{eff,air}}$ [-]",'Interpreter','latex','FontSize',20);
end
xlabel("$c$ [-]",'Interpreter','latex','FontSize',20);
ylim([0.7 1.2]);
set(gca,'TickLabelInterpreter','latex','FontSize',20);
box on;
grid on;
ax = gca;
axis on;
ax.LineWidth = 2;
ax.GridColor = [0 0 1];

hold on;


end

title('$\chi_{H_2} = '+string(h2_pc(i_h2)/100)+'$','Interpreter','latex','FontSize',30);
l = legend("$\Phi = 0.5$","$\Phi = 1.0$");
l.Interpreter = 'latex';
l.Location = 'southeast';
set(gca,'TickLabelInterpreter','latex','FontSize',30);

end

set(gcf,'OuterPosition',[500 500 1200 500]);


%% Saving

% saveas(gcf,"figures/sigma_ratio.png");
% saveas(gcf,"figures/sigma_ratio.fig");


