% TSEL.M          (Tournament Selection)
%
% This function performs selection with the Tournament Selection process.
%
% Syntax:  NewChrIx = tsel(FitnV, Nsel, NTourn)
%
% Input parameters:
%    FitnV     - Column vector containing the fitness values of the
%                individuals in the population.
%    Nsel      - number of individuals to be selected
%    NTourn    - number of tournament selection partitions
%
% Output parameters:
%    NewChrIx  - column vector containing the indexes of the selected
%                individuals relative to the original population, shuffled.
%                The new population, ready for mating, can be obtained
%                by calculating OldChrom(NewChrIx,:).



function NewChrIx = tsel(FitnV,Nsel,Ntour);

    if nargin < 3, Ntour = 20; end
    
% Identify the population size (Nind)
   [Nind,ans] = size(FitnV);
   NewChrIx = [];
   for i=1:Nsel 
      randTour = randi([1 Nind],1,Ntour);
      max = FitnV(1);
      ind_max = randTour(1);
      for j=1:length(randTour)
          if (max < FitnV(randTour(j)))
              max = FitnV(randTour(j));
              ind_max = randTour(j);
          end
      end
      NewChrIx(i)= ind_max;
   end
    
% 
% Perform stochastic universal sampling
%    cumfit = cumsum(FitnV);
%    trials = cumfit(Nind) / Nsel * (rand + (0:Nsel-1)');
%    Mf = cumfit(:, ones(1, Nsel));
%    Mt = trials(:, ones(1, Nind))';
%    [NewChrIx, ans] = find(Mt < Mf & [ zeros(1, Nsel); Mf(1:Nind-1, :) ] <= Mt);

% Shuffle new population
   [ans, shuf] = sort(rand(Nsel, 1));
   NewChrIx = NewChrIx(shuf);


% End of function