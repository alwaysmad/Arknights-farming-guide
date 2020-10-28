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
%% the moment of truth
% we use linprog for Pareto optimality
% construct f
tmp = ones(numel(activity_names), 1);
f = - D' * tmp;
LB = zeros(numel(item_names), 1);
UB = Inf*ones(numel(item_names), 1);
options = optimoptions('linprog','Display','iter','Algorithm','dual-simplex');
options.Preprocess = 'none';
% vector of sanity values
V = linprog(f, D, zeros(numel(activity_names), 1), A_eq, V_preset, LB, UB, options);
% revenue vector
R = D*V;