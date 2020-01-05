 %%
%Hyperparameters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NIND=650;       % Number of individuals
MAXGEN=850;     % Maximum no. of generations
DEADLINE=0.4;     % Seconds of available computational time
NVAR=26;        % No. of variables
PRECI=1;        % Precision of variables
ELITIST=0.1;    % percentage of the elite population
GGAP=1-ELITIST;     % Generation gap
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=.95;     % probability of crossover
PR_MUT=.25;       % probability of mutation
LOCALLOOP=0;      % local loop removal
CROSSOVER = 'path_circle';  % default crossover operator
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
for datasetnumber=10:10
% start with first dataset
data = load(['datasets/' datasets{datasetnumber}]);
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);
k=i;
end

crossovers = ["path_circle","cross_edrec","cross_pmx"];

%my_run_ga_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, crossovers(4), LOCALLOOP, ah1, ah2, ah3);
%{
for c = 1:length(crossovers)  
    for sample = 1:5
        sample
        k=1;
        for PR_CROSS=0:0.05:1
          sample_measured(sample, k)= my_run_ga_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, crossovers(c), LOCALLOOP, ah1, ah2, ah3);
          k=k+1;
        end
    end
    output_crosses(c,:)=mean(sample_measured);
end


figure('name','Different rates of crossover')
plot(0:0.05:1,output_crosses(1,:))
hold on
plot(0:0.05:1,output_crosses(2,:))
hold on
plot(0:0.05:1,output_crosses(3,:))

legend('Cycle Path','Edge Recombination','Partially Mapped');
xlabel('%age crossover')
ylabel('Best distance at particular crossover rate')
axis('tight')

%}

%FOR CROSSOVER PERFORMANCE OVER 900 GENERATIONS
%{
PR_CROSS_choose = [0 0.9 0.2];
keep=zeros(3,1000);
for c = 3:length(crossovers)  
    crossovers(c)
    
    for sample = 1:20
    sample
      %  for gen= 5:300
   
      data = my_run_ga_path(1,x, y, NIND, 1000, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS_choose(c), PR_MUT, crossovers(c), LOCALLOOP, ah1, ah2, ah3);
      keep(sample, 1:length(data)) = data;
      if(length(data)<1000)
          keep(sample,length(data)+1:end)=interp1(1:length(data),data,length(data)+1:length(keep),'makima');
          disp('Edited this much length');
          length(length(data):length(keep))
      end
      keep
     %   end
     %   sample_measured(sample,:)= keep(:); 
    end
    
    output_crosses(c,:)=mean(keep(1:20,:))
end


%min_len = min([length(output_crosses(1,1:find(output_crosses(1,:)==0,1))) length(output_crosses(2,1:find(output_crosses(2,:)==0,1))) length(output_crosses(3,1:find(output_crosses(3,:)==0,1)))]);
figure('name','Different rates of crossover')
plot(1:50:1000/2,output_crosses(1,1:50:1000/2))
hold on
plot(1:50:1000/2,output_crosses(2,1:50:1000/2))
hold on
plot(1:50:1000/2,output_crosses(3,1:50:1000/2))

legend('Cycle Path','Edge Recombination','Partially Mapped');
xlabel('Generations')
ylabel('Best distance at particular generation')
axis('tight')
%}

cas = 1;
%Different cross over operators
%{
k=1;
for PR_CROSS=0:0.05:1
  output_altedge(k) = my_run_ga_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
    k=k+1;
end

CROSSOVER = 'path_circle';
k=1;
for PR_CROSS=0:0.05:1
  output_circlec(k) = my_run_ga_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3);
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
%}


%FOR CROSSOVER ITERATIONS
%{
for c = 1:length(crossovers) 
    for k=1:1000
      output_best(k) = my_run_ga_path(1,x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, crossovers(c), LOCALLOOP, ah1, ah2, ah3);
    end
    crossovers(c)
    [mean(output_best(1:10)) mean(output_best(1:100)) mean(output_best(1:1000))]
end
%}
%{
for c = 3:length(crossovers) 
    crossovers(c)
for sample=1:3
    sample
    k=1;
    for PR_CROSS=0:0.05:1
          PR_CROSS
          sample_read(sample,k) = my_run_ga_path(1,x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, crossovers(c), LOCALLOOP, ah1, ah2, ah3);
          k=k+1;
    end
end

output_probz(c,:)=mean(sample_read(1:3,:))

end
figure('name','Different rates of crossover')
plot(0:0.05:1,output_probz(1,:))
hold on
plot(0:0.05:1,output_probz(2,:))
hold on
plot(0:0.05:1,output_probz(3,:))

legend('Cycle Path','Edge Recombination','Partially Mapped');
xlabel('%age crossover')
ylabel('Best distance at particular crossover rate')
axis('tight')
%}

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
disp('Mutations')
%{
for cas=1:4  
     for k=1:1000
        output_mutz(cas,k) = my_run_ga_path(cas, x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, crossovers(1), LOCALLOOP, ah1, ah2, ah3);
     end
     cas
    [mean(output_mutz(cas,1:10)) mean(output_mutz(cas,1:100)) mean(output_mutz(cas,1:1000))]
end

%}
%{
%Run this loop 100 times for different cases of mutation (so 100
%lineages)

for cas=1:4
     start = tic;    
     for k=1:100
        output(k,i) = my_run_ga_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, crossover(1), LOCALLOOP, ah1, ah2, ah3);
     end
     params(1,i) = NIND;

     i = i+1;
end
output

%}

%FOR MUTATION RATE
%{
mutz={'Invert subset','Swap individuals','Insert randomly','Scramble subset'};
PR_CROSS = 0.9;
PR_MUT_choose=[0.5 0.55 0.35 0.75];
for cas=4:4  
    mutz(cas)
    for sample = 1:2
        sample
        i=1;
        %for PR_MUT=0:0.05:1
        for maxg = 50:50:1000
            maxg
            MAXGEN = maxg;
            prmutz_sample(sample,i) = my_run_ga_path(cas, x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT_choose(cas), crossovers(2), LOCALLOOP, ah1, ah2, ah3);
            i = i+1;
        end  
    end    
    output_prmutz(cas,:)=mean(prmutz_sample(1:2,:))
end
%figure('name','Different rates of mutation')
figure('name','Different rates of mutation')

plot(50:50:1000,output_prmutz(1,1:20))
hold on
plot(50:50:1000,output_prmutz(2,1:20))
hold on
plot(50:50:1000,output_prmutz(3,1:20))
hold on
plot(50:50:1000,output_prmutz(4,1:20))
legend(mutz);
%xlabel('%age mutation')
xlabel('Generation')
ylabel('Best distance at particular generation')
%ylabel('Best distance at particular mutation rate')
axis('tight')
%}

%POPULATION SIZE AFTER CALCULATING XOVER, MUT OPZ AND %
mutz={'Invert subset','Swap individuals','Insert randomly','Scramble subset'};
PR_CROSS = 0.9;
PR_MUT = 0.35;

for cas=1:4  
    mutz(cas)
    for sample = 1:1
        sample
        i=1;
        for maxp = 50:50:1000
            maxp
            NIND = maxp;
            prmutz_sample(sample,i) = my_run_ga_path(cas, x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, crossovers(2), LOCALLOOP, ah1, ah2, ah3);
            i = i+1;
        end  
    end    
    output_prmutz(cas,:)=mean(prmutz_sample(1:2,:))
end
%figure('name','Different rates of mutation')
figure('name','Different rates of mutation')

plot(50:50:1000,output_prmutz(1,:))
hold on
plot(50:50:1000,output_prmutz(2,:))
hold on
plot(50:50:1000,output_prmutz(3,:))
hold on
plot(50:50:1000,output_prmutz(4,:))
legend(mutz);
%xlabel('%age mutation')
xlabel('Generation')
ylabel('Best distance at particular generation')
%ylabel('Best distance at particular mutation rate')
axis('tight')




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
         
         