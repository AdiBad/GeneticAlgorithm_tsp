%%
%Hyperparameters
clear
close all
clc
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
 %plot(x,y,'ko')
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
for datasetnumber=1:1
% start with first dataset
data = load(['datasets/' datasets{datasetnumber}]);
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);
k=i;
end


cas = 1;
%Different cross over operators
k=1;
for PR_CROSS=0:0.05:1
  output_altedge(k) = my_run_ga(cas, x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
    k=k+1;
end
CROSSOVER = 'path_circle';
k=1;
for PR_CROSS=0:0.05:1
  output_circlec(k) =  my_run_ga_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
    k=k+1;
end
k=1;
for PR_CROSS=0:0.05:1
  output_edrec(k) = run_ga_edge_recomb( x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
    k=k+1;
end

figure('name','Different rates of crossover')
plot(0:0.05:1,output_altedge)
hold on
plot(0:0.05:1,output_circlec)
hold on
plot(0:0.05:1,output_edrec)

legend('Alternating Edge','Cycle Path','Edge Recombination');
xlabel('%age crossover')
ylabel('Best distance at particular crossover rate')
axis('tight')


for k=1:1000
  output_edrec(k) = run_ga_edge_recomb( x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
end


%FOR CROSSOVER ITERATIONS
%{
cas = 1;
%Different cross over operators
for k=1:1000
  output_altedge(k) = my_run_ga(cas, x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
end
CROSSOVER = 'path_circle';
for k=1:1000
  output_circlec(k) =  my_run_ga_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
end

mean(output_altedge)
mean(output_circlec)
%}


%FOR CROSSOVER PERCENTAGE
%{
cas = 1;
%Different cross over operators
k=1;
for PR_CROSS=0:0.05:1
  output_altedge(k) = my_run_ga(cas, x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
    k=k+1;
end
CROSSOVER = 'path_circle';
k=1;
for PR_CROSS=0:0.05:1
  output_circlec(k) =  my_run_ga_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
    k=k+1;
end
k=1;
for PR_CROSS=0:0.05:1
  output_edrec(k) = run_ga_edge_recomb( x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
    k=k+1;
end

figure('name','Different rates of crossover')
plot(0:0.05:1,output_altedge)
hold on
plot(0:0.05:1,output_circlec)
hold on
plot(0:0.05:1,output_edrec)

legend('Alternating Edge','Cycle Path','Edge Recombination');
xlabel('%age crossover')
ylabel('Best distance at particular crossover rate')
axis('tight')
%}

%{
figure('name','Crossover over iterations')'
plot(output_altedge)
hold on
plot(output_circlec)
legend('Alternating Edge','Circular Path');
xlabel('Iteration')
ylabel('Best distance at particular crossover')
%}

%FOR MUTATION ITERATIONS
%{
%Run this loop 100 times for different cases of mutation (so 100
%lineages)

for cas=1:4
     start = tic;
     
     for k=1:100
        output(k,i) = my_run_ga(cas, x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
     end
     params(1,i) = NIND;

     i = i+1;
end
output

%}

%FOR MUTATION RATE
%{
for cas=1:4  
    i=1;
    for PR_MUT=0:0.05:1
        output(cas,i) = my_run_ga(cas, x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
        i = i+1;
    end
    
end
output
close all
figure('name','Different rates of mutation')
plot(0:0.05:1,output(1,:))
hold on
plot(0:0.05:1,output(2,:))
hold on
plot(0:0.05:1,output(3,:))
hold on
plot(0:0.05:1,output(4,:))
legend('Invert subset','Swap individuals','Insert randomly','Scramble subset');
xlabel('%age mutation')
ylabel('Best distance at particular mutation rate')
axis('tight')

%}


%for i=1:size(output,2)
%    plot(output(:,i));
%    hold on    
%end
%legend('Invert subset','Swap individuals','Insert randomly','Scramble subset');
%xlabel('Iteration')
%ylabel('Best distance at particular mutation')
%hold off;

%{
% Calculate Success Rate
threshold = 3.35;
for k=1:length(output(1,:))
    n_success(k) = 0;
    for z=1:length(output(:,k))
        if round(output(z,k), 4) <= threshold
             n_success(k) = n_success(k) + 1;
        end
    end
end
success_rate = n_success / length(output(1,:));
[SucMax,MaxTh] = max(success_rate);
%}