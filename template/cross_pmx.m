%% usage:edge_pmx(selch)
%selch is a matrix of individual chromosomes that represent adjacency list
%of cities
%This function performs partially mapped crossover for 2 rows of a matrix 
%and assigns the offspring to the odd row, loop over all the rows
%ref: https://www.youtube.com/watch?v=c2ft8AG8JKE

function offspring = cross_pmx(selch,~)
%{
selch=[9	2	11	14	5	12	8	6	10	15	13	4	3	1	16	7
11	15	4	12	2	6	5	9	7	8	1	14	10	3	13	16
5	14	4	11	9	15	16	3	2	1	6	12	8	10	13	7
2	14	7	1	10	6	9	11	16	8	4	13	5	12	15	3
15	5	4	16	9	2	11	1	7	8	14	6	13	10	12	3
13	9	12	14	1	11	4	8	3	15	7	5	2	10	16	6
11	9	12	2	3	5	1	6	4	14	15	13	7	8	16	10
10	16	4	7	2	8	3	12	9	14	6	5	1	11	13	15
2	15	1	12	14	9	7	8	13	5	16	11	4	10	6	3
9	3	8	2	5	14	4	7	6	10	11	12	16	1	13	15
13	14	2	1	10	8	12	4	11	6	9	3	16	7	5	15
3	6	9	10	4	5	15	16	13	12	2	8	7	14	1	11
10	8	4	16	13	5	9	15	11	2	6	1	7	3	14	12
2	14	7	1	10	6	9	11	16	8	4	13	5	12	15	3
7	11	1	8	5	15	16	14	9	4	13	10	6	12	2	3
14	10	11	9	2	12	8	15	7	5	4	1	3	13	6	16
5	12	11	14	2	3	16	7	15	1	6	10	13	4	9	8
11	9	12	2	3	5	1	6	4	14	15	13	7	8	16	10
11	15	1	12	16	4	6	9	3	5	10	13	8	7	14	2
8	15	7	11	3	1	10	12	5	9	4	14	2	16	6	13
2	11	13	14	6	7	9	12	8	4	5	15	10	3	16	1
15	9	6	4	14	1	12	8	16	7	10	5	11	3	2	13
3	8	13	15	12	10	16	1	4	14	7	6	2	9	11	5
15	12	5	13	14	10	7	1	11	9	16	8	2	4	3	6
9	13	6	7	10	11	15	1	2	4	16	8	5	3	12	14
9	2	11	14	5	12	8	6	10	15	13	4	3	1	16	7
2	6	11	3	4	1	10	5	16	9	13	8	12	15	14	7
14	11	4	2	6	12	3	8	1	13	16	9	5	7	15	10
14	10	11	9	2	12	8	15	7	5	4	1	3	13	6	16
5	14	11	3	1	13	10	8	16	12	9	6	15	7	2	4
10	9	4	7	6	14	15	16	12	2	3	8	11	13	1	5
9	11	12	7	13	8	5	2	4	6	15	1	3	14	10	16
10	1	4	12	7	14	16	11	2	6	5	15	9	13	3	8
5	16	7	8	15	12	6	9	14	3	4	10	1	13	2	11
7	11	1	8	5	15	16	14	9	4	13	10	6	12	2	3
10	12	2	3	7	13	1	11	15	6	4	16	5	8	14	9
5	16	7	8	15	12	6	9	14	3	4	10	1	13	2	11
5	14	11	3	1	13	10	8	16	12	9	6	15	7	2	4
14	6	12	15	10	4	16	13	11	2	1	5	9	8	7	3
6	14	4	15	8	3	5	7	9	13	16	11	2	10	12	1
12	4	9	14	3	15	7	1	2	13	6	10	16	5	8	11
2	15	1	12	14	9	7	8	13	5	16	11	4	10	6	3
15	11	13	2	14	10	1	7	5	9	4	8	6	16	3	12
10	9	4	7	6	14	15	16	12	2	3	8	11	13	1	5
15	9	6	4	14	1	12	8	16	7	10	5	11	3	2	13
11	15	1	12	16	4	6	9	3	5	10	13	8	7	14	2
13	14	2	1	10	8	12	4	11	6	9	3	16	7	5	15
12	11	1	10	9	5	2	4	16	8	7	3	15	13	14	6
]
%}

[l_a l_b]= size(selch);
offspring = selch;

for rows = 1:2:l_a-1
   % selch
    rows;
    a = selch(rows+1,:);
    b = selch(rows,:);
    %{
    if (a==b)
        disp('Stop')
        break;
    end
    %}
    
    %Limit for subset of data to inherit (ensure 2 different limits)
    
    limz = sort([ceil(rand(1)*l_b), ceil(rand(1)*l_b)]);
     while(diff(limz)<=1)
         limz = sort([ceil(rand(1)*l_b), ceil(rand(1)*l_b)]);
     end
    
  %{
  while(limz(2)-limz(1)<2)
   %     limz(1) = ceil(rand(1)*l_b);
    %    limz(2) = ceil(rand(1)*l_b);
     %   sort(limz)
    %end
   
    %}
    %At least one element should crossover, else let parents pass
    if(diff(limz)>=1)
        span_a = a(limz(1):limz(2));
        span_b = b(limz(1):limz(2));

        map = containers.Map(span_a,span_b);

        %Resolve transitive dependency

        valz = map.values;
        keyz = map.keys;

        visited=zeros(1,length(span_a)); 
        for m=1:map.Count
            %Check if value at this position is also a key somewhere 
            if(isKey(map,valz(m)))
               key = keyz(m);
               if(visited(visited == key{1}))
                   continue
               else
                   transitive_key = map(key{1});
                   visited(m)=transitive_key;
                   final_value = map(transitive_key);
                 
                   %Should not equal key and value or key and value of value
                   if(transitive_key ~= key{1} && key{1} ~= map(map(key{1})))
                      map(key{1})=final_value;
                      map.remove(transitive_key);
                   end
               end
           end
        end

        newkeyz = map.keys;
        newvalz = map.values;  

        %For offspring 1

        %Replace the legal offsprings
        for orig=1:map.Count
            loc = find(a==newkeyz{orig});
            if(loc)
               a(loc) = newvalz{orig};
            end
        end
        %Replace by saved subset
        a(limz(1):limz(2))=span_a;

        %For offspring 2
          %Replace the legal offsprings
        for orig=1:map.Count
            loc = find(b==newvalz{orig});
            if(loc)
               b(loc) = newkeyz{orig};
            end
        end
        %Replace by saved subset
        b(limz(1):limz(2))=span_b;

        offspring(rows,:)=a;
        offspring(rows+1,:)=b;
    end
end

