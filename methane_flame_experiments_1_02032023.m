%% Resetting console
close all
clc
clear

%% Reading image file

%% Background (N = 100)

% Background signal
cnt = 0;
I_b = zeros(2160,2560);

path = "/Volumes/TOSHIBA EXT/CambridgeExperiments/H2 project/experiments/02_03_2023_Zyla5p5/bg_1mJ.tif";
N = length(imfinfo(path));

% images within each batch
    for k = 1:N
        cnt = cnt+1;
        disp("Reading background image "+string(k)+"/"+string(N)+"...");
        I_temp = imread(path,k);
        I_b = I_b + double(I_temp);
    end

I_b_mean = I_b./cnt;

%% Reference - Air (N = 1000)

% Reference : Air
cnt = 0;
I_Rref = zeros(2160,2560);

for X = 0:1:5
% tif image batch
if X == 0
    path = "/Volumes/TOSHIBA EXT/CambridgeExperiments/H2 project/experiments/02_03_2023_Zyla5p5/air_310mJ.tif";
else
    path = "/Volumes/TOSHIBA EXT/CambridgeExperiments/H2 project/experiments/02_03_2023_Zyla5p5/air_310mJ_X"+string(X)+".tif";
end
N = length(imfinfo(path));

% images within each batch
    for k = 1:N
        cnt = cnt+1;
        disp("Reading reference image "+string(k)+"/"+string(N)+"...");
        I_temp = imread(path,k);
        I_Rref = I_Rref + double(I_temp);
    end
end

I_Rref_mean = I_Rref./cnt;


%% Chemiluminescence (N = 702)

% Chemiluminescence
cnt = 0;
I_chem = zeros(2160,2560);

for X = 0:1:3
% tif image batch
if X == 0
    path = "/Volumes/TOSHIBA EXT/CambridgeExperiments/H2 project/experiments/02_03_2023_Zyla5p5/chem_1mJ.tif";
else
    path = "/Volumes/TOSHIBA EXT/CambridgeExperiments/H2 project/experiments/02_03_2023_Zyla5p5/chem_1mJ_X"+string(X)+".tif";
end
N = length(imfinfo(path));

if X==3
    N = 120;
end

% images within each batch
    for k = 1:N
        cnt = cnt+1;
        disp("Reading chemiluminescence image "+string(k)+"/"+string(N)+"...");
        I_temp = imread(path,k);
        I_chem = I_chem + double(I_temp);
    end
end

I_chem_mean = I_chem./cnt;


%% Flame (N = 1000)

% Flame
cnt = 0;
I_R = zeros(2160,2560);

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
        I_R = I_R + double(I_temp);
    end
end

I_R_mean = I_R./cnt;
