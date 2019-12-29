%%
%Hyperparameters
clear all;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NIND=50;		% Number of individuals
MAXGEN=100;		% Maximum no. of generations
DEADLINE=0.4;     % Seconds of available computational time
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.05;    % percentage of the elite population
GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
LOCALLOOP=0;      % local loop removal
CROSSOVER = 'xalt_edges';  % default crossover operator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% load the data sets
datasetslist = dir('datasets/');datasetslist = dir('datasets/');
datasets=cell( size(datasetslist,1)-2,1);datasets=cell( size(datasetslist,1)-2 ,1);
for i=1:size(datasets,1);
    datasets{i} = datasetslist(i+2).name;
end



fh = figure('Visible','off','Name','TSP Tool','Position',[0,0,1024,768]);
ah1 = axes('Parent',fh,'Position',[.1 .55 .4 .4]);
% plot(x,y,'ko')
ah2 = axes('Parent',fh,'Position',[.55 .55 .4 .4]);
axes(ah2);
xlabel('Generation');
ylabel('Distance (Min. - Gem. - Max.)');
ah3 = axes('Parent',fh,'Position',[.1 .1 .4 .4]);
axes(ah3);
title('Histogram');


%%
% Perform runs over the set of parameters and take final answer and mean
% values over time.

samples = 10;
i=1;
i=1;
figure(3);
datasetchosen = [1 6 10];
nind = [50 100 200];
maxgen = [100 300 500];
for datasetnumber=1:3
% start with first dataset
data = load(['datasets/' datasets{datasetchosen(datasetnumber)}]);
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);
k=i;
MAXGEN = maxgen(datasetnumber);
NIND= nind(datasetnumber);
    for PR_MUT=0:0.05:1
                
                
%                      disp(i);
                     start = tic;
                     for j=1 : samples
                        output(j,i) = my_run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
%                         clc;
%                         disp(i);
%                         disp(j);
                     end
                     params(1,i) = PR_MUT;
                     params(2,i) = toc(start);
                     i = i+1;
    end
    dvector = mean(output(:,k:i-1));
    [minimum,mintheta] = min(dvector);
    disp(mintheta);
%     dvector = (dvector / norm(dvector))+(datasetnumber/3)*0.05;
    plot(dvector)
    hold on;
    plot(dvector,'o')
    hold on;
end

hold off;

% %%
% % Calculate Success Rate
% threshold = 3.35;
% for k=1:length(output(1,:))
%     n_success(k) = 0;
%     for z=1:length(output(:,k))
%         if round(output(z,k), 4) <= threshold
%              n_success(k) = n_success(k) + 1;
%         end
%     end
% end
% success_rate = n_success / length(output(1,:));
% [SucMax,MaxTh] = max(success_rate)
