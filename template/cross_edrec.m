%% usage:edge_recomb(selch)
%selch is a matrix of individual chromosomes that represent adjacency list
%of cities
%This function performs edge crossover for 2 rows of a matrix and assigns
%the offspring to the odd row, loop over all the rows

function offspring = cross_edrec(selch,~)
[l_a l_b ]= size(selch);

offspring = selch;
for rows = 1:l_a-1
    a = selch(rows,:);
    b = selch(rows+1,:);
    can_visit = unique([a,b]);
  
    nburs(1,:) = [a(1);b(1);a(end);b(end)];
    %Unite all the neighbours from both parents
    for i=2:l_b
       nburs(i,:) = [a(i);b(i);a(i-1);b(i-1);]; 
    end

    for i=1:l_b
        
        %Begin by randomly selecting a neighbour
        select = nburs(i,ceil(rand_int(1,1,[1,4])));
        %If it is already visited, choose another neighbour
        while(~ismember(select,can_visit))
            %If all neighbours exhausted, assign a selection randomly
            if(sum(nburs(i,:))==0)
                select = can_visit(i,ceil(rand_int(1,1,[1,length(can_visit)])));
                break;
            else
                if (~intersect(nburs(i,:),can_visit))
                    select = can_visit(i,ceil(rand_int(1,1,[1,length(can_visit)])));
                    break;
            end
            
         select = nburs(i,ceil(rand_int(1,1,[1,4])));
        end
        %Remove the possibility of visiting that city again
        can_visit(can_visit==select)=[];
        nburs(i,(nburs(i,:)==select))=0;
        %Assign the city to offspring in that row
        offspring(rows,i) = select;        
    end
end
end