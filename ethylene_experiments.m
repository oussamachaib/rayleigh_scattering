%% Resetting console
close all
clc
clear

%% Reading image file
% Reading .tif extensions

% Background : Air + Laser off
path = "/Users/oussamachaib/Desktop/Experiments/experiments/23_02_2023_Zyla5p5/C2H4/bg_255us_1mJ.tif";
N = length(imfinfo(path));
bg = struct([]);

for k = 1:N
disp("Reading background image "+string(k)+"/"+string(N)+"...");
bg{k} = imread(path);
end

% Reference : Air
path = "/Users/oussamachaib/Desktop/Experiments/experiments/23_02_2023_Zyla5p5/C2H4/air_5us_310mJ.tif";
N = length(imfinfo(path));
Iref = struct([]);

for k = 1:N
disp("Reading reference image "+string(k)+"/"+string(N)+"...");
Iref{k} = imread(path);
end

% Measurement : Ethylene (C2H4)

path = "/Users/oussamachaib/Desktop/Experiments/experiments/23_02_2023_Zyla5p5/C2H4/c2h4_5us_310mJ.tif";
I = struct([]);

for k = 1:N
disp("Reading non-reference image "+string(k)+"/"+string(N)+"...");
I{k} = imread(path);
end

%% Plotting reference and measurement images

% Background
figure();
t = tiledlayout(2,5);
t.Padding = 'tight';
t.TileSpacing = 'none';

for k = 1:N
nexttile();
imshow(bg{k});
caxis([0 500]);
colormap("hot");
end

% Reference
figure();
t = tiledlayout(2,5);
t.Padding = 'tight';
t.TileSpacing = 'none';

for k = 1:N
nexttile();
imshow(Iref{k});
caxis([0 10000]);
colormap("hot");
end

% Measurement
figure();
t = tiledlayout(2,5);
t.Padding = 'tight';
t.TileSpacing = 'none';

for k = 1:N
nexttile();
imshow(I{k});
caxis([0 10000]);
colormap("hot");
end

%% Plotting ratio I/Iref

figure();
t = tiledlayout(2,5);
t.Padding = 'tight';
t.TileSpacing = 'none';

for k = 1:N
nexttile();
If = medfilt2(I{k} - bg{k} - Iref{k},[3,3]);
Ireff = medfilt2(Iref{k} - bg{k},[3,3]);
If = imgaussfilt(If,3);
Ireff = imgaussfilt(Ireff,3);

R = double(If)./double(Ireff);
%R = imdiffusefilt(R,'ConductionMethod','quadratic','NumberOfIterations',50);
imshow(R);
[Y,X] = find(bwperim(imbinarize(imgaussfilt(R,15))));
hold on;
plot(X,Y,'.w','MarkerSize',5);
caxis([0 .7]);
colormap('hot');
end

% for k = 1:N
% nexttile();
% I2 = (I{k} - bg{k} - Iref{k});
% I1 = (Iref{k} - bg{k});
% imshow(I2-I1);
% caxis([0 10000]);
% colormap('hot');
% end





