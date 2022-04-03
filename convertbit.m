function [gen_param, gen_cost] = convertbit(pop, n_pop, n_param, n_bits_param, lb, ub, func_handle)
    %create the parameters and function values
    gen_param = zeros(n_pop, n_param);
    gen_cost = zeros(n_pop, 1);
    for j = 1:n_pop
        n_bits_prev = 1;
        for k = 1:n_param
            bit = 0;
            for l = n_bits_prev:(n_bits_prev+n_bits_param(k)-1)
                bit = bit + pop{j}(l)*2^((n_bits_prev+n_bits_param(k)-1)-l);                               
            end
            n_bits_prev = n_bits_prev + n_bits_param(k);
            gen_param(j,k) = lb(k) + ((ub(k)-lb(k))/(2^(n_bits_param(k)) - 1))*bit;
        end
        gen_cost(j,1) = func_handle(gen_param(j,1:n_param));
    end
end