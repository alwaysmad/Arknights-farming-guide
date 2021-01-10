%% construct V_preset - vector of known sanity values of items
% and construct A_eq - matrix needed for linprog
V_preset = zeros(numel(item_names), 1);
A_eq = zeros(numel(item_names));
% sanity is worth 1 of itself
sanity_item_index = item_indices('AP_GAMEPLAY');
V_preset(sanity_item_index) = 1;
A_eq(sanity_item_index, sanity_item_index) = 1;
% set sanity value of gold
V_preset(gold_item_index) = gold_sanity_value;
A_eq(gold_item_index, gold_item_index) = 1;
% set sanity value of LMD
V_preset(LMD_item_index) = LMD_sanity_value;
A_eq(LMD_item_index, LMD_item_index) = 1;
% set sanity value of T1 EXP card
V_preset(T1_exp_card_item_index) = exp_sanity_value * 200;
A_eq(T1_exp_card_item_index, T1_exp_card_item_index) = 1;
% set sanity value of T2 EXP card
V_preset(T2_exp_card_item_index) = exp_sanity_value * 400;
A_eq(T2_exp_card_item_index, T2_exp_card_item_index) = 1;
% set sanity value of T3 EXP card
V_preset(T3_exp_card_item_index) = exp_sanity_value * 1000;
A_eq(T3_exp_card_item_index, T3_exp_card_item_index) = 1;
% set sanity value of T4 EXP card
V_preset(T4_exp_card_item_index) = exp_sanity_value * 2000;
A_eq(T4_exp_card_item_index, T4_exp_card_item_index) = 1;
%% tricks
% a trick to calculate building material cost correctly
A_eq(item_indices('3131'),:) = D(activity_indices('x1'),:); % Craft: Light Building Material
A_eq(item_indices('3132'),:) = D(activity_indices('x2'),:); % Craft: Concrete Building Material
A_eq(item_indices('3133'),:) = D(activity_indices('x3'),:); % Craft: Reinforced Building Material
% a trick to artificially lower t1 and t2 costs linking them to t3 costs
% trough crafting 
A_eq(item_indices('30062'),:) = D(activity_indices('x19'),:); % Craft: Device
A_eq(item_indices('30063'),:) = D(activity_indices('x20'),:); % Craft: Integrated Device
A_eq(item_indices('30052'),:) = D(activity_indices('x22'),:); % Craft: Polyketon
A_eq(item_indices('30053'),:) = D(activity_indices('x23'),:); % Craft: Aketon
A_eq(item_indices('30042'),:) = D(activity_indices('x25'),:); % Craft: Oriron
A_eq(item_indices('30043'),:) = D(activity_indices('x26'),:); % Craft: Oriron Cluster
A_eq(item_indices('30032'),:) = D(activity_indices('x28'),:); % Craft: Polyester
A_eq(item_indices('30033'),:) = D(activity_indices('x29'),:); % Craft: Polyester Pack
A_eq(item_indices('30022'),:) = D(activity_indices('x31'),:); % Craft: Sugar
A_eq(item_indices('30023'),:) = D(activity_indices('x32'),:); % Craft: Sugar Pack
A_eq(item_indices('30012'),:) = D(activity_indices('x34'),:); % Craft: Orirock Cube
A_eq(item_indices('30013'),:) = D(activity_indices('x35'),:); % Craft: Orirock Cluster
%% the moment of truth
% we use linprog for Pareto optimality
% construct f
% a trick to calculate building material cost correctly
tmp = ones(numel(activity_names), 1);
% tmp(activity_indices('x1')) = 0;
% tmp(activity_indices('x2')) = 0;
% tmp(activity_indices('x3')) = 0;
f = - D' * tmp;
LB = zeros(numel(item_names), 1);
UB = Inf*ones(numel(item_names), 1);
options = optimoptions('linprog','Display','iter','Algorithm','dual-simplex');
options.Preprocess = 'none';
% vector of sanity values
V = linprog(f, D, zeros(numel(activity_names), 1), A_eq, V_preset, LB, UB, options);
% revenue vector
R = D*V;