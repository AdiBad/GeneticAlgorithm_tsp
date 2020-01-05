
%%
%Hyperparameters
clear all;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NIND=50;        % Number of individuals
MAXGEN=100;     % Maximum no. of generations
DEADLINE=0.4;     % Seconds of available computational time
NVAR=26;        % No. of variables
PRECI=1;        % Precision of variables
ELITIST=0.05;    % percentage of the elite population
GGAP=1-ELITIST;     % Generation gap
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=.95;     % probability of crossover 
PR_MUT=.05;       % probability of mutation
LOCALLOOP=0;      % local loop removal
CROSSOVER = 'path_circle';  % default crossover operator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% load the data sets
%datasetslist = dir('datasets/');
datasetslist = dir('C:\Users\r0768685\Downloads\GeneticAlgorithm_tsp-20200103T160235Z-001\GeneticAlgorithm_tsp\TSPBenchmark');
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

samples = 1;
i=1;
% figure(3);
maxgen = [75 550 850];
pop = [125 250 650];

x_l = zeros(12,1);
y_l = zeros(12,1);
%CROSSOVER = "cross_edrec";

for datasetnumber=1:5
    % start with first dataset
    data = load(['C:\Users\r0768685\Downloads\GeneticAlgorithm_tsp-20200103T160235Z-001\GeneticAlgorithm_tsp\TSPBenchmark\' datasets{datasetnumber}]);
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    NVAR=size(data,1);
    append_xvalz = [];
    append_yvalz = [];
    for model = 3:3
        k=i;
        MAXGEN = maxgen(model);
        NIND= pop(model);
        
        PR_MUT = 0.35;
        PR_CROSS = 0.95;
        
        start = tic;
        for j=1 : samples
            j
            start = tic;
            output(j,i) = my_run_ga_benchmark(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
            params(1,j) = PR_CROSS;
            params(2,j) = toc(start);
        end
        i = i+1;
        XX = ["Dataset ",datasets{datasetnumber},' model', model];
        disp(XX);
        YY = ["Mean Value ",mean(output(:,i-1)),' mean time needed ', mean(params(2,j))];
        disp(YY);
        pause(0.1);
        x_l(i) = mean(output(:,i-1));
        y_l(i) = mean(params(2,j));
        
        append_xvalz=[append_xvalz XX]
        append_yvalz=[append_yvalz YY];
    end   
end
