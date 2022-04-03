function [minima_gen, min_param] = ga(n_bits_param, n_param, n_pop, lb, ub, func_handle)
    %finds the minimum of a function using a genetic algorithm,
    %n_bits_param is an array specifying the resolution of each variable
    %n_param is an integer specifying the number of parameters
    %n_pop is an integer number of members in the population
    %ub and lb are arrays giving the upper and lower boundaries of the
    %variables
    
    %generate initial population
    n_bits_tot = sum(n_bits_param);
    initial_pop = cell(n_pop,1);
    for i = 1:n_pop
        initial_pop{i} = randi([0,1],1,n_bits_tot);
    end
    %generation loop
    n_gen_max = 300;
    pop = initial_pop;
    minima_gen = [];
    min_param = [];
    for i = 1:n_gen_max
        %create the parameters and function values
        [gen_param, gen_cost] = convertbit(pop, n_pop, n_param, n_bits_param, lb, ub, func_handle);
        %check for convergence
        [sort_cost, index] = sort(gen_cost);
        minima_gen = [minima_gen, sort_cost(1)];
        sort_param = gen_param(index,:); 
        min_param = [min_param; sort_param(1,:)];
        if i > 15 && abs(sort_cost(1)- minima_gen(i-15)) < 0.001
            disp('minimum found at generation: ');
            disp(i);
            break;
        end
        %implement elitism to minimal 20 percent of generation
        gen_bit = cell2mat(pop);
        sort_gen_bit = gen_bit(index,:);
        elitists = sort_gen_bit(1:round(0.2*n_pop),:);
        %create children
        parents = randperm(n_pop);
        children = [];
        for j = 1:n_pop/2
            parent1 = pop{parents(j)}; 
            parent2 = pop{parents(n_pop+1-j)};
            cut = randi(n_bits_tot);
            child1 = [parent1(1:cut),parent2(cut+1:n_bits_tot)];
            child2 = [parent2(1:cut),parent1(cut+1:n_bits_tot)];
            children = [children;child1;child2];
        end
        %add mutations
        for j = 1:n_pop
           for k = 1:n_bits_tot
               mutation = randi(1000);
               if mutation == 1 && children(j,k) == 1
                   children(j,k) = 0;
               elseif mutation == 1 && children(j,k) == 0
                   children(j,k) = 1;
               end
           end
        end
        %find the best 80 percent of children and combine them with the 20
        %percent elitists
        children = mat2cell(children, ones(1,n_pop));
        [gen_param_child, gen_cost_child] = convertbit(children, n_pop, n_param, n_bits_param, lb, ub, func_handle);
        [sort_cost_c, index_c] = sort(gen_cost_child);
        gen_bit = cell2mat(children);
        sort_gen_bit = gen_bit(index_c,:);
        best_children = sort_gen_bit(1:round(0.8*n_pop),:);
        pop2 = [best_children;elitists];
        pop2 = mat2cell(pop2, ones(1,n_pop));
        pop = pop2;
    end

    figure;
    plot(minima_gen); xlabel('generation'); ylabel('Function minimum');
    for i = 1:n_param
        figure;
        plot(min_param(:,i));xlabel('generation'); ylabel(['optimum of parameter ' int2str(i)]);
    end
end