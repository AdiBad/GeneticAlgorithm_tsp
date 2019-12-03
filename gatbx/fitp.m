function fitpop = fitp(FitnV,Nsel)
%{
Makes list of individuals with fitness greater than a random number
%}

[Nind,ans] = size(FitnV);

prob = FitnV/sum(FitnV);
cum_prob = cumsum(prob);
rand_num = rand()
fitpop = zeros(Nsel,1);
j=1;
for i=1:Nind
    if(prob(i)>rand_num && Nsel ~= 0)
        fitpop(j)= i;
        Nsel = Nsel - 1;   
        j= j+1;
    end
end

end


