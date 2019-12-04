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

prob = FitnV/sum(FitnV);
cum_prob = cumsum(prob);
rand_num = prob(ceil((Nind-1)*rand()))
fitpop = [];

j = 1;
i = 1;

while(Nsel ~= 0)
    if(i ~= Nind)
      if(prob(i)>rand_num)  
          fitpop(j)= i;
          Nsel = Nsel - 1;   
          j= j+1;
      end
    else
      rand_num = prob(ceil((Nind-1)*rand()))
      i = 0;
    end
    
    i = i + 1;
      
end

%{ 
Fill remaining spots randomly
if(Nsel ~= 0)
  for i = 1:Nsel
     fitpop(j) = ceil((Nsel-1)*rand()) ;
     if(fitpop(j) == 0)
         fitpop(j) = ceil((Nsel-2)*rand());
     end
     j = j + 1 ;
  end
end  
%}
end


