% FITP.M          (Fitness Proportional Selection)
%
% This function performs selection with the Fitness Proportional Selection 
% process.
%
% Syntax:  fitpop = fitp(FitnV,Nsel)
%
% Input parameters:
%    FitnV     - Column vector containing the fitness values of the
%                individuals in the population.
%    Nsel      - number of individuals to be selected
%   
% Output parameters:
%    fitpop  - column vector containing the indices of the selected
%                individuals greater than a randomly selected fitness 
%                probability.
%                The new population, ready for mating, can be obtained
%                by calculating OldChrom(fitpop,:).


function fitpop = fitp(FitnV,Nsel)
%{
Makes list of individuals with fitness greater than a random number
%}
    
[Nind,ans] = size(FitnV);

fits(:,1) = FitnV;
fits(:,2) = [1:length(FitnV)];

%Convert fitness into probability of survival
fits(:,1) = fits(:,1)/sum(fits(:,1));
%Sort by decreasing order of probability
fits = sortrows(fits,1);
%Make cumulative sum for each probability
fits(:,1) = cumsum(fits(:,1));

fitpop = [];

j = 1;
while(Nsel ~= 0)
    %Calculate a random number before each individual is selected
    rand_num = rand();
    threshold = 0;
    %Find out where this trial is "binned" in/nearest individual
    for i = 1:length(fits(:,1))
        if (fits(i,1) > rand_num & fits(i,1)>threshold)
           %Assign index of selected individual
           fitpop(j) = fits(i,2);
           j = j + 1;
           Nsel = Nsel - 1;  
           break
        else
            continue
        end
    end
    
end

end