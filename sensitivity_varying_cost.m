
load ('data.mat');

%% pre-setting (make sure to setup the SAVE section as well!!)

price = price_original;
%price = price_rescale_2cv;
whether_fit = false;
num = size(production,2);       % number of power plants
sim = 100; % times of simulation
result_diff_cost_original = struct;

%% start loops

for var_pv = 1:3
    for var_wind = 1:3
        for var_storage = 1:3
            
            var = [0.9,1,1.1];
            ratio_PV = var(var_pv);
            ratio_wind = var(var_wind);
            ratio_storage = var(var_storage);

            record_diff_cost = zeros(sim,12);
            capital_cost = capital;
            capital_cost(1:4) = capital(1:4) * ratio_PV;
            capital_cost(5:8) = capital(5:8) * ratio_wind;
            capital_cost(9) = capital(9) * ratio_storage;

%% ------------------------Without storage-------------------------
%% 100% & 25% scenarios

% AN EMPTY MATRIX are created to record
% ROWS: scenarios
% COLUMES:
%   1: number of simulation; 
%   2-10: weights (["Solar north","Solar east","Solar west","Solar south","Wind north","Wind east","Wind west","Wind south","storage"];)
%   11: average monthly revenue [EUR]
%   12: risk [EUR]

record_sce = zeros (10,12);

% Simulate 8 100% scenarios
for n = 1:num
    w = zeros (1,num+1);        % 9 weights, including storage
    w(n) = 1;
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_sce(n,:) = [n,w,revenue,risk];
end

% Simulate 2 25% scenarios
w = [0.25,0.25,0.25,0.25,0,0,0,0,0];            % only solar plants
[revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
record_sce(9,:) = [n,w,revenue,risk];

w = [0,0,0,0,0.25,0.25,0.25,0.25,0];            % only wind plants
[revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
record_sce(10,:) = [n,w,revenue,risk];

%% simulation: 4 locations * wind

sim = 1000; % times of simulation
record_wind = zeros (sim,12);

% simulation: only varies 5th-8th weight (of wind plants)
for n = 1:sim
    rng(n);
    % starting from all zeros
    w = zeros (1,num+1); % 9, including storage
    % random order to assign weight
    order = datasample([5:8],4,'Replace',false);
    % 'rand' function: random number from uniform distribution [0,1]
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    % to ensure that weights sum up to 1
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_wind(n,:) = [n,w,revenue,risk];
end
% to combine with scarios above
record_wind = [record_wind;record_sce(5:8,:);record_sce(10,:)];
% scatter (record_wind(:,12),record_wind(:,11),'bx')
disp('only wind calculating...')

%% simulation: 4 locations * solar

record_solar = zeros (sim,12);
for n = 1:sim
    rng(n);
    w = zeros (1,num+1);
    order = datasample([1:4],4,'Replace',false);
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_solar(n,:) = [n,w,revenue,risk];
end
record_solar = [record_solar;record_sce(1:4,:);record_sce(9,:)];
%scatter (record_solar(:,12),record_solar(:,11),'rx')
disp('only solar calculating...')

%% simulation: NORTH * 2 tech

record_N = zeros (sim,12);
for n = 1:sim
    rng(n);
    w = zeros (1,num+1);
    order = datasample([1,5],2,'Replace',false);
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_N(n,:) = [n,w,revenue,risk];
end
record_N = [record_N;record_sce(1,:);record_sce(5,:)];
%scatter (record_N(:,12),record_N(:,11),'gx')
disp('only north calculating...')

%% simulation: EAST * 2 tech
sim = 500;
record_E = zeros (sim,12);
for n = 1:sim
    rng(n);
    w = zeros (1,num+1);
    order = datasample([2,6],2,'Replace',false);
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_E(n,:) = [n,w,revenue,risk];
end
record_E = [record_E;record_sce(2,:);record_sce(6,:)];
%scatter (record_E(:,12),record_E(:,11),'gx')
disp('only east calculating...')

%% simulation: WEST * 2 tech
sim = 500;
record_W = zeros (sim,12);
for n = 1:sim
    rng(n);
    w = zeros (1,num+1);
    order = datasample([3,7],2,'Replace',false);
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_W(n,:) = [n,w,revenue,risk];
end
record_W = [record_W;record_sce(3,:);record_sce(7,:)];
%scatter (record_W(:,12),record_W(:,11),'gx')
disp('only west calculating...')

%% simulation: SOUTH * 2 tech
sim = 500;
record_S = zeros (sim,12);
for n = 1:sim
    rng(n);
    w = zeros (1,num+1);
    order = datasample([4,8],2,'Replace',false);
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_S(n,:) = [n,w,revenue,risk];
end
record_S = [record_S;record_sce(4,:);record_sce(8,:)];
%scatter (record_S(:,12),record_S(:,11),'gx')
disp('only south calculating...')

%% simulation: 4 locations * 2 tech
sim = 3000; % times of simulation
record_new = zeros (sim,12);
for n = 1:sim
    rng(n);
    w = zeros (1,num+1);
    order = datasample([1:num],num,'Replace',false);
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_new(n,:) = [n,w,revenue,risk];
end
record_without_storage = [record_wind;record_solar;record_N;record_E;record_W;record_S;record_sce;record_new];
record_more = intensify(record_without_storage,budget, production,price,capital,false,whether_fit,fit_wind,fit_solar);
record_without_storage = [record_without_storage;record_more];

%scatter (record_without_storage(:,12),record_without_storage(:,11),'kx')

disp('all simulations calculating...')

%% ------------------------With storage--------------------------
%% 100% storage
w = [0,0,0,0, 0,0,0,0, 1];
[revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
record_only_storage = [1,w,revenue,risk];

%% simulation: 4 locations * 2 tech + storage

sim = 500; % times of simulation
record_with_storage = zeros(sim,12);
for n = 1:sim
    rng(n);
    w = zeros (1,num+1);
    order = datasample([1:num+1],num+1,'Replace',false);
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_with_storage(n,:) = [n,w,revenue,risk];
end
record_with_storage = [record_with_storage;record_only_storage;record_without_storage];
record_more = intensify(record_with_storage,budget, production,price,capital,true,whether_fit,fit_wind,fit_solar);
record_with_storage = [record_with_storage;record_more];

%scatter (record_with_storage(:,12),record_with_storage(:,11),'kx')

disp('all simulations calculating...')

%% simulation: NORTH * 2 tech + storage
sim = 500;
record_N_with = zeros (sim,12);
for n = 1:sim
    rng(n);
    w = zeros (1,num+1);
    order = datasample([1,5,num+1],3,'Replace',false);
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_N_with(n,:) = [n,w,revenue,risk];
end
record_N_with = [record_N_with;record_sce(1,:);record_sce(5,:)];
disp('only north calculating...')

%% simulation: EAST * 2 tech + storage

record_E_with = zeros (sim,12);
for n = 1:sim
    rng(n);
    w = zeros (1,num+1);
    order = datasample([2,6,num+1],3,'Replace',false);
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_E_with(n,:) = [n,w,revenue,risk];
end
record_E_with = [record_E_with;record_sce(2,:);record_sce(6,:)];
%scatter (record_E(:,12),record_E(:,11),'gx')
disp('only east calculating...')

%% simulation: WEST * 2 tech + storage

record_W_with = zeros (sim,12);
for n = 1:sim
    rng(n);
    w = zeros (1,num+1);
    order = datasample([3,7,num+1],3,'Replace',false);
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_W_with(n,:) = [n,w,revenue,risk];
end
record_W_with = [record_W_with;record_sce(3,:);record_sce(7,:)];
%scatter (record_W(:,12),record_W(:,11),'gx')
disp('only west calculating...')

%% simulation: SOUTH * 2 tech + storage

record_S_with = zeros (sim,12);
for n = 1:sim
    rng(n);
    w = zeros (1,num+1);
    order = datasample([4,8,num+1],3,'Replace',false);
    for i = order(1:(end-1))
        w (i) = (1-sum(w))*rand;
    end
    w (order(end)) = (1-sum(w));
    [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_S_with(n,:) = [n,w,revenue,risk];
end
record_S_with = [record_S_with;record_sce(4,:);record_sce(8,:)];
%scatter (record_S(:,12),record_S(:,11),'gx')
disp('only south calculating...')


%% ------------------------Save---------------------------------- 
%% save

result_diff_cost_original(var_pv,var_wind,var_storage).price = price;
result_diff_cost_original(var_pv,var_wind,var_storage).capital_cost = capital_cost;


result_diff_cost_original(var_pv,var_wind,var_storage).record_sce = record_sce;
result_diff_cost_original(var_pv,var_wind,var_storage).record_wind = record_wind;
result_diff_cost_original(var_pv,var_wind,var_storage).record_solar = record_solar;

result_diff_cost_original(var_pv,var_wind,var_storage).record_N = record_N;
result_diff_cost_original(var_pv,var_wind,var_storage).record_E = record_E;
result_diff_cost_original(var_pv,var_wind,var_storage).record_W = record_W;
result_diff_cost_original(var_pv,var_wind,var_storage).record_S = record_S;

result_diff_cost_original(var_pv,var_wind,var_storage).record_without_storage = record_without_storage;

result_diff_cost_original(var_pv,var_wind,var_storage).record_only_storage = record_only_storage;
result_diff_cost_original(var_pv,var_wind,var_storage).record_with_storage = record_with_storage;


result_diff_cost_original(var_pv,var_wind,var_storage).record_N_with = record_N_with;
result_diff_cost_original(var_pv,var_wind,var_storage).record_E_with = record_E_with;
result_diff_cost_original(var_pv,var_wind,var_storage).record_W_with = record_W_with;
result_diff_cost_original(var_pv,var_wind,var_storage).record_S_with = record_S_with;

%%
save('results_sensitivity.mat','-regexp','original$','2cv$','3cv$','-append');

str = sprintf('done: %.2f %.2f %.2f',ratio_PV,ratio_wind,ratio_storage);
disp(str)
        end
    end
end
