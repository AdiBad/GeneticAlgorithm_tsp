function run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3)
% usage: run_ga(x, y, 
%               NIND, MAXGEN, NVAR, 
%               ELITIST, STOP_PERCENTAGE, 
%               PR_CROSS, PR_MUT, CROSSOVER, 
%               ah1, ah2, ah3)
%
%
% x, y: coordinates of the cities
% NIND: number of individuals
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% STOP_PERCENTAGE: percentage of equal fitness (stop criterium)
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% CROSSOVER: the crossover operator
% calculate distance matrix between each pair of cities
% ah1, ah2, ah3: axes handles to visualise tsp
{NIND MAXGEN NVAR ELITIST STOP_PERCENTAGE PR_CROSS PR_MUT CROSSOVER LOCALLOOP}

        fit_count = 0;
        GGAP = 1 - ELITIST;
        mean_fits=zeros(1,MAXGEN+1);
        worst=zeros(1,MAXGEN+1);
        Dist=zeros(NVAR,NVAR);
        for i=1:size(x,1)
            for j=1:size(y,1)
                Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            end
        end
        % initialize population
        Chrom=zeros(NIND,NVAR);
        for row=1:NIND
            
            %Adjacency representation
            Chrom(row,:)=path2adj(randperm(NVAR));
            
            %Path representation
            %Chrom(row,:)=randperm(NVAR);
            
        end
        gen=0;
        % number of individuals of equal fitness needed to stop
        stopN=ceil(STOP_PERCENTAGE*NIND);
        % evaluate initial population
        ObjV = tspfun(Chrom,Dist);
        best=zeros(1,MAXGEN);
        % generational loop
        while gen<MAXGEN
            sObjV=sort(ObjV);
            
            %Sorting by fitness
            fit_count = fit_count + 1;
          	
            best(gen+1)=min(ObjV);
        	minimum=best(gen+1);
            mean_fits(gen+1)=mean(ObjV);
            worst(gen+1)=max(ObjV);
            %This loop extracts the index of minimum value from ObjVal
            for t=1:size(ObjV,1)
                
                %If minimum fitness value (best) is encountered, break loop
                fit_count = fit_count + 1;
                
                if (ObjV(t)==minimum)
                    break;
                end
            end
            
            %Display the adjacency list from the min position 
            visualizeTSP(x,y,adj2path(Chrom(t,:)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
            gen
            %TERMINATING CONDITION GIVEN HERE:
            if (fit_count >= 10000)
                gen
                  break;
            end          
        	%assign fitness values to entire population
        	FitnV=ranking(ObjV);
            
        	%select individuals for breeding -----------------------------
        	SelCh=select('sus', Chrom, FitnV, GGAP);
            
        	%recombine individuals (crossover)
            SelCh = recombin(CROSSOVER,SelCh,PR_CROSS);
            SelCh=mutateTSP('inversion',SelCh,PR_MUT,1);
            %evaluate offspring, call objective function
        	SelCh(SelCh == 0) = 1;
            ObjVSel = tspfun(SelCh,Dist);
            %reinsert offspring into population
        	[Chrom ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);        
            Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom,LOCALLOOP,Dist);
        	%increment generation counter
        	gen=gen+1;            
        end
end

function d = b2d(b)
    M = reshape([b{:}], length(b), []);
	d = [128, 64, 32, 16, 8, 4, 2, 1] * M
end
