%%
%Hyperparameters
clear all;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NIND=100;		% Number of individuals
MAXGEN=100;		% Maximum no. of generations
DEADLINE=0.4;     % Seconds of available computational time
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.1;    % percentage of the elite population
GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=1;     % probability of crossover 
PR_MUT=.45;       % probability of mutation
LOCALLOOP=0;      % local loop removal
CROSSOVER = 'path_circle';  % default crossover operator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% load the data sets
%datasetslist = dir('datasets/');
datasetslist = dir('datasets/');
datasets=cell( size(datasetslist,1)-2,1);

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


%
% Perform runs over the set of parameters and take final answer and mean
% values over time.

%samples = 3;
i=1;
% figure(3);
%First comment the other population size, only change threshold generations

maxgen = [50:50:1000];

%pop = [50:25:500];

selz = ["sus","tsel","fitp"];
%selz=["tsel"];

for datasetnumber=10:10
    % start with first dataset
  
    data = load(['datasets/' datasets{datasetnumber}]);
    
    x=data(:,1)/max([data(:,1);data(:,2)]);
    y=data(:,2)/max([data(:,1);data(:,2)]);
    
        sample_reading = zeros(4,length(maxgen));
    NVAR=size(data,1);
    for model = 1:3
        for sample = 1:10
            sample
             for j=1 : length(maxgen)               
                 MAXGEN = maxgen(j);
                [data, ~] = my_run_ga_eval_benchmark(selz(model), x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
                sample_reading(sample, j) = data;
             end           
        end
        output(model,:) = mean(sample_reading(:))
        i = i+1;
        XX = ["Dataset ",datasets{datasetnumber},' model', selz(model)];
        disp(XX);
    end   
end

%{
figure('name','Performance of different slection functions with varying population size')
plot(pop, output(1,:));
hold on
plot(pop, output(2,:));
hold on
plot(pop, output(3,:));
hold off
legend(selz)
xlabel('Population size');
ylabel('Best round trip distance')
%}

figure('name','Performance of different slection functions with varying generation size')
plot(maxgen, sample_reading(1,:));
hold on
plot(maxgen, sample_reading(2,:));
hold on
plot(maxgen, sample_reading(3,:));
hold off
legend(selz)
xlabel('Generations');
ylabel('Best round trip distance')
%{%}